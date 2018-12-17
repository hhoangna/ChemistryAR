//
//  ShowModelVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/19/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import MultipeerConnectivity

class ShowModelVC: BaseVC {
    // MARK: - IBOutlets
    
    @IBOutlet weak var sessionInfoView: UIView!
    @IBOutlet weak var sessionInfoLabel: UILabel!
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var sendMapButton: UIButton!
    @IBOutlet weak var moreModelBtn: UIButton!
    @IBOutlet weak var mappingStatusLabel: UILabel!
    @IBOutlet weak var vModel: UIView?
    @IBOutlet weak var clvContent: UICollectionView!
    @IBOutlet weak var csHeightViewModel: NSLayoutConstraint!
    
    // MARK: - View Life Cycle
    
    var multipeerSession: MultipeerSession!
    var mapProvider: MCPeerID?
    var modelAR: SCNNode?
    var nameAR: String? = ""
    
    var statusSelected: Int = 0
    var isUpdateData: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        multipeerSession = MultipeerSession(receivedDataHandler: receivedData)
        setupTabBarItemView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        vModel?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        vModel?.layer.cornerRadius = 15
        vModel?.isHidden = true
        
        self.addDismissKeyboardDetector()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        // Start the view's AR session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
        // Set a delegate to track the number of plane anchors for providing UI feedback.
        sceneView.session.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Prevent the screen from being dimmed after a while as users will likely
        // have long periods of interaction without touching the screen or buttons.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's AR session.
        sceneView.session.pause()
        self.removeDismissKeyboardDetector()
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: clvContent ?? UIView()) ?? false {
            return false
        }
        
        return true
    }
    
    func setupTabBarItemView() {
        if topItemView == nil {
            topItemView = TabBarTopView.load()
            topItemView?.delegate = self
        }
        
        let tabMine = TabBarItem.init("Mine".localized, nil, AppColor.mainColor)
        let tabLibrary = TabBarItem.init("Library".localized, nil, AppColor.mainColor)
        
        topItemView?.tabBarTopItems = [tabMine,tabLibrary]
        if let tabBarItem = topItemView {
            tabBarTopItemView?.addSubview(tabBarItem, edge: UIEdgeInsets.zero)
        }
    }
    
    @IBAction func btnMoreARModelPressed(_ sender: UIButton) {
//        vModel?.animShow()
//        self.moreModelBtn.isHidden = true
//        self.sendMapButton.isHidden = true
        let vc: ModelVC = .load(SB: .AR)
        self.present(vc, animated: true, completion: nil)

    }
    
    @IBAction func btnHideARModelPressed(_ sender: UIButton) {
        vModel?.animHide()
        self.moreModelBtn.isHidden = false
        self.sendMapButton.isHidden = false
    }
}

extension ShowModelVC: ARSCNViewDelegate {
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let name = anchor.name, name.hasPrefix("panda") {
            node.addChildNode(loadRedPandaModel(nameAR))
        }
    }
}

extension ShowModelVC: ARSessionDelegate {
    // MARK: - ARSessionDelegate
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    /// - Tag: CheckMappingStatus
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            sendMapButton.isEnabled = false
        case .extending:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        case .mapped:
            sendMapButton.isEnabled = !multipeerSession.connectedPeers.isEmpty
        }
        mappingStatusLabel.text = frame.worldMappingStatus.description
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
    }
    
    // MARK: - ARSessionObserver
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay.
        sessionInfoLabel.text = "Session was interrupted"
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required.
        sessionInfoLabel.text = "Session interruption ended"
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user.
        sessionInfoLabel.text = "Session failed: \(error.localizedDescription)"
        resetTracking(nil)
    }
    
    func sessionShouldAttemptRelocalization(_ session: ARSession) -> Bool {
        return true
    }
    
    @IBAction func btnCancelPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Multiuser shared session
    
    /// - Tag: PlaceCharacter
    @IBAction func handleSceneTap(_ sender: UITapGestureRecognizer) {
        
        // Hit test to find a place for a virtual object.
        guard let hitTestResult = sceneView
            .hitTest(sender.location(in: sceneView), types: [.existingPlaneUsingGeometry, .estimatedHorizontalPlane])
            .first
            else { return }
        
        // Place an anchor for a virtual character. The model appears in renderer(_:didAdd:for:).
        let anchor = ARAnchor(name: "panda", transform: hitTestResult.worldTransform)
        sceneView.session.add(anchor: anchor)
        
        // Send the anchor info to peers, so they can place the same content.
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: anchor, requiringSecureCoding: true)
            else { fatalError("can't encode anchor") }
        self.multipeerSession.sendToAllPeers(data)
    }
    
    /// - Tag: GetWorldMap
    @IBAction func shareSession(_ button: UIButton) {
        sceneView.session.getCurrentWorldMap { worldMap, error in
            guard let map = worldMap
                else { print("Error: \(error!.localizedDescription)"); return }
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: map, requiringSecureCoding: true)
                else { fatalError("can't encode map") }
            self.multipeerSession.sendToAllPeers(data)
        }
    }
    
    /// - Tag: ReceiveData
    func receivedData(_ data: Data, from peer: MCPeerID) {
        
        do {
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // Run the session with the received world map.
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                
                // Remember who provided the map for showing UI feedback.
                mapProvider = peer
            }
            else
                if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                    // Add anchor to the session, ARSCNView delegate adds visible content.
                    sceneView.session.add(anchor: anchor)
                }
                else {
                    print("unknown data recieved from \(peer)")
            }
        } catch {
            print("can't decode data recieved from \(peer)")
        }
    }
    
    // MARK: - AR session management
    
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        // Update the UI to provide feedback on the state of the AR experience.
        let message: String
        
        switch trackingState {
        case .normal where frame.anchors.isEmpty && multipeerSession.connectedPeers.isEmpty:
            // No planes detected; provide instructions for this app's AR interactions.
            message = "Move around to map the environment, or wait to join a shared session."
            
        case .normal where !multipeerSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = multipeerSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            message = "Connected with \(peerNames)."
            
        case .notAvailable:
            message = "Tracking unavailable."
            
        case .limited(.excessiveMotion):
            message = "Tracking limited - Move the device more slowly."
            
        case .limited(.insufficientFeatures):
            message = "Tracking limited - Point the device at an area with visible surface detail, or improve lighting conditions."
            
        case .limited(.initializing) where mapProvider != nil,
             .limited(.relocalizing) where mapProvider != nil:
            message = "Received map from \(mapProvider!.displayName)."
            
        case .limited(.relocalizing):
            message = "Resuming session — move to where you were when the session was interrupted."
            
        case .limited(.initializing):
            message = "Initializing AR session."
            
        default:
            // No feedback needed when tracking is normal and planes are visible.
            // (Nor when in unreachable limited-tracking states.)
            message = ""
            
        }
        
        sessionInfoLabel.text = message
        sessionInfoView.isHidden = message.isEmpty
    }
    
    @IBAction func resetTracking(_ sender: UIButton?) {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    // MARK: - AR session management
    
    func addAnimation(node: SCNNode) {
        let rotateOne = SCNAction.rotateBy(x: 0, y: CGFloat(Float.pi), z: 0, duration: 5.0)
        let hoverUp = SCNAction.moveBy(x: 0, y: 0.2, z: 0, duration: 2.5)
        let hoverDown = SCNAction.moveBy(x: 0, y: -0.2, z: 0, duration: 2.5)
        let hoverSequence = SCNAction.sequence([hoverUp, hoverDown])
        let rotateAndHover = SCNAction.group([rotateOne, hoverSequence])
        let repeatForever = SCNAction.repeatForever(rotateAndHover)
        let scale = SCNAction.scale(by: 0.05, duration: 0.3)
        node.runAction(repeatForever)
        node.runAction(scale)
    }
    
    private func loadRedPandaModel(_ name: String?) -> SCNNode {
        let sceneURL = Bundle.main.url(forResource: name!, withExtension: "scn", subdirectory: "art.scnassets")!
        let referenceNode = SCNReferenceNode(url: sceneURL)!
        addAnimation(node: referenceNode)
        referenceNode.load()
        
        return referenceNode
    }
    
    private func configModelWith(_ url:URL) -> SCNNode{
        let referenceNode = SCNReferenceNode(url: url)!
        addAnimation(node: referenceNode)
        referenceNode.load()
        
        return referenceNode
    }
}

extension ShowModelVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(collectionView.frame.size)
        return collectionView.frame.size;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0;
    }
}

extension ShowModelVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topItemView?.tabBarTopItems.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CellModel = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CellModel
        
        cell.rootVC = self
        cell.tabSelected = statusSelected
        if statusSelected == 0 {
            cell.nameCallback = {[weak self] (success, name) in
                if success {
                    self?.nameAR = name
                }
            }
        } else {
            cell.urlCallback = {[weak self] (success, url) in
                if success {
                    self?.modelAR = self?.configModelWith(url)
                }
            }
        }
        
        return cell
    }
}

extension ShowModelVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUpdateData = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topItemView?.updateContraintViewSelectedDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        topItemView?.scrollViewDidEndDecelerating(scrollView)
        
        isUpdateData = true
        let contentOffsetX = scrollView.contentOffset.x
        let indexSelect = Int(contentOffsetX / ScreenSize.SCREEN_WIDTH)
        
        if indexSelect == 0 {
            statusSelected = 0
        } else {
            statusSelected = 1
        }
        clvContent.reloadData()
    }
}

extension ShowModelVC: TabBarTopViewDelegate {
    func didSelectedTabBarTopItem(tabBarTopItemView: TabBarTopView, indexBarItem: Int) {
        print("IndexTabBarItem:\(indexBarItem)")
        isUpdateData = true
        if indexBarItem == 0 {
            statusSelected = 0
        } else {
            statusSelected = 1
        }
        
        scrollToPageSelected(indexBarItem)
    }
    
    func scrollToPageSelected(_ indexPage:Int) {
        let width = self.view.frame.size.width
        let pointX = CGFloat(indexPage) * width
        
        clvContent?.contentOffset =  CGPoint(x: pointX, y: (clvContent?.contentOffset.y)!);
        clvContent?.reloadData()
    }
}

extension ShowModelVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select cc")
    }
}

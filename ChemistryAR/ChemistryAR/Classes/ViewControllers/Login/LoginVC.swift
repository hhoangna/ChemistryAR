//
//  LoginVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import AVFoundation

class LoginVC: BaseVC {
    
    var avPlayer: AVPlayer!
    var avPlayerLayer: AVPlayerLayer!
    var paused: Bool = false
    
    @IBOutlet weak var clvContent: UICollectionView?
    @IBOutlet weak var vEffect: UIVisualEffectView?

    override func viewDidLoad() {
        super.viewDidLoad()

        initUI()
        setupTabBarItemView()
        setupBackgroundVideo()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupTabBarItemView() {
        topItemView = TabBarTopView.load()
        topItemView?.delegate = self
        
        let tabLogin = TabBarItem.init("LOGIN".localized, #imageLiteral(resourceName: "ic_Login"), AppColor.mainColor)
        let tabRegister = TabBarItem.init("REGISTER".localized, #imageLiteral(resourceName: "ic_Register"), AppColor.purpleColor)
        
        topItemView?.tabBarTopItems = [tabLogin,tabRegister]
        if let tabBarItem = topItemView {
            tabBarTopItemView?.addSubview(tabBarItem, edge: UIEdgeInsets.zero)
        }
    }
    
    func setupBackgroundVideo() {
        let theURL = Bundle.main.url(forResource: "video_background", withExtension: "mp4")
        
        avPlayer = AVPlayer(url: theURL!)
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avPlayer.volume = 0
        avPlayer.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
        
        avPlayerLayer.frame = view.layer.bounds
        view.backgroundColor = UIColor.clear;
        view.layer.insertSublayer(avPlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.avPlayer?.currentItem, queue: .main) { _ in
            self.avPlayer?.seek(to: CMTime.zero)
            self.avPlayer?.play()
        }
    }
    
    func initUI() {
        if #available(iOS 11.0, *) {
            clvContent?.clipsToBounds = true
            clvContent?.layer.cornerRadius = 10
            clvContent?.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            
            tabBarTopItemView?.clipsToBounds = true
            tabBarTopItemView?.layer.cornerRadius = 10
            tabBarTopItemView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        
        vEffect?.layer.cornerRadius = 15
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.play()
        paused = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        avPlayer.pause()
        paused = true
    }
}

extension LoginVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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


//MARK : - UICollectionViewDataSource
extension LoginVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if (indexPath.row == 0) {
            let cell: LoginCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoginClvCell", for: indexPath) as! LoginCell
            
            cell.rootVC = self
            
            return cell;
        } else {
            let cell: RegisterCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterClvCell", for: indexPath) as! RegisterCell
            
            cell.rootVC = self
            
            return cell;
        }
        
    }
}

//MARK: - UIScrollViewDelegate
extension LoginVC:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        topItemView?.updateContraintViewSelectedDidScroll(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        topItemView?.scrollViewDidEndDecelerating(scrollView)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

//MARK: - TabBarTopViewDelegate
extension LoginVC: TabBarTopViewDelegate {
    
    func didSelectedTabBarTopItem(tabBarTopItemView: TabBarTopView, indexBarItem: Int) {
        scrollToPageSelected(indexBarItem)
        view.endEditing(true)
    }
    
    func scrollToPageSelected(_ indexPage:Int) {
        let width = self.view.frame.size.width * 0.9
        let pointX = CGFloat(indexPage) * width
        
        clvContent?.contentOffset =  CGPoint(x: pointX, y: (clvContent?.contentOffset.y)!);
        UIView.animate(withDuration: 0.2) {
            self.loadViewIfNeeded()
        }
    }
}

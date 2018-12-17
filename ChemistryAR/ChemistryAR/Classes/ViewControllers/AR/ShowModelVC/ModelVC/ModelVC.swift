//
//  ModelVC.swift
//  ChemistryAR
//
//  Created by Admin on 12/17/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import ARKit

typealias ARNameCallback = (_ success: Bool, _ name: String) -> Void
typealias ARURLCallback = (_ success: Bool, _ file: URL) -> Void

class ModelVC: BaseVC {

    @IBOutlet weak var vContent: UIView?
    @IBOutlet weak var clvContent: UICollectionView!
    @IBOutlet weak var csHeightViewModel: NSLayoutConstraint!
    
    var statusSelected: Int = 0
    var isUpdateData: Bool = true
    var modelAR: ARFileModel?
    var nameAR: String? = ""
    
    var nameARModel: ARNameCallback?
    var urlARModel: ARURLCallback?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        showModelViewWithAnimation()
        vContent?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        vContent?.layer.cornerRadius = 15
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isEmpty(nameAR) {
            nameARModel!(true, E(nameAR))
        }
        if modelAR?.urlLocal != nil {
            urlARModel!(true, (modelAR?.urlLocal)!)
        }
    }
    
    @objc func showModelViewWithAnimation()  {
        let height = vContent?.frame.size.height ?? 0
        
        vContent?.transform = CGAffineTransform(translationX: 0, y: height)
        UIView.animate(withDuration: 0.3) {
            self.vContent?.transform = .identity
        }
    }
    
    func hideModelView()  {
        let height = vContent?.frame.size.height ?? 0
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self?.vContent?.transform = CGAffineTransform(translationX: 0, y: height)
        }) {[weak self] (isFinish) in
            self?.dismiss(animated: false, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if let touch = touches.first {
            if touch.view != self.vContent {
                hideModelView()
            }
        }
    }

    @IBAction func btnHideARModelPressed(_ sender: UIButton) {
        hideModelView()
    }
}

extension ModelVC: UICollectionViewDelegateFlowLayout {
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

extension ModelVC: UICollectionViewDataSource {
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
            cell.fileCallback = {[weak self] (success, file) in
                if success {
                    self?.modelAR = file
                }
            }
        }
        
        return cell
    }
}

extension ModelVC: UIScrollViewDelegate {
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

extension ModelVC: TabBarTopViewDelegate {
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

extension ModelVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select cc")
    }
}

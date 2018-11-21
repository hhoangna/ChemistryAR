//
//  ScanModelListVC.swift
//  ChemistryAR
//
//  Created by Admin on 11/21/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ScanModelListVC: BaseVC {
    
    @IBOutlet weak var clvContent: UICollectionView?

    var isUpdateData: Bool = true
    
    var indexSelected: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }
    
    func updateUI() {
        setupCollectionView()
        setupTabBarItemView()
    }
    
    func setupCollectionView()  {
        clvContent?.delegate = self
        clvContent?.dataSource = self
    }
    
    func setupTabBarItemView() {
        if topItemView == nil {
            topItemView = TabBarTopView.load()
            topItemView?.delegate = self
        }
        
        let tabMine = TabBarItem.init("Mine")
        let tabAll = TabBarItem.init("Gallery")
        
        topItemView?.tabBarTopItems = [tabMine,tabAll]
        if let tabBarItem = topItemView {
            tabBarTopItemView?.addSubview(tabBarItem, edge: UIEdgeInsets.zero)
        }
    }
}

extension ScanModelListVC: UICollectionViewDelegateFlowLayout{
    
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

extension ScanModelListVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topItemView?.tabBarTopItems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ScanModelClv = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ScanModelClv
        
        cell.rootVC = self
        if isUpdateData {
            //cell.updateData(tabId: tabSelected, search: strSearch)
        }
        
        return cell;
    }
}

//MARK: - UIScrollViewDelegate
extension ScanModelListVC: UIScrollViewDelegate{
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
        let status: Int = Int(contentOffsetX / ScreenSize.SCREEN_WIDTH)
        
        if status == 0 {
            indexSelected = 0
        } else {
            indexSelected = 1
        }
        clvContent?.reloadData()
    }
}


//MARK: - TabBarTopViewDelegate
extension ScanModelListVC: TabBarTopViewDelegate {
    func didSelectedTabBarTopItem(tabBarTopItemView: TabBarTopView, indexBarItem: Int) {
        print("IndexTabBarItem:\(indexBarItem)")
        isUpdateData = true
        
        if indexBarItem == 0 {
            indexSelected = 0
        } else {
            indexSelected = 1
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

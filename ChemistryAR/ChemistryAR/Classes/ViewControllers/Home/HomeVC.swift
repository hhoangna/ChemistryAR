//
//  HomeVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import FSPagerView

enum AR_Features: Int {
    case AR_Periodic = 0;
    case AR_Reaction = 1;
    case AR_ARKit = 2;
    case AR_Setting = 3;
    
    static let count: Int = {
        var max: Int = 0
        while let _ = AR_Features(rawValue: max) { max += 1 }
        return max
    }()
    
    var icon:UIImage?{
        switch self {
        case .AR_Periodic:
            return #imageLiteral(resourceName: "ic_Periodic")
        case .AR_Reaction:
            return #imageLiteral(resourceName: "ic_Reaction")
        case .AR_ARKit:
            return #imageLiteral(resourceName: "ic_AR")
        case .AR_Setting:
            return #imageLiteral(resourceName: "ic_Setting")
        }
    }
    
    var name:String?{
        switch self {
        case .AR_Periodic:
            return "Periodic Table".localized
        case .AR_Reaction:
            return "Chemical Reaction".localized
        case .AR_ARKit:
            return "Augmented Reality".localized
        case .AR_Setting:
            return "Setting".localized
        }
    }
}

class HomeVC: BaseVC {
    
    @IBOutlet weak var clvContent:UICollectionView?
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    var arrBanners = [UIImage(named: "ic_banner1"), UIImage(named: "ic_banner2"), UIImage(named: "ic_banner3"), UIImage(named: "ic_banner4")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
//        setupBannerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupBannerView() {
        pagerView.transformer = FSPagerViewTransformer(type: .depth)
        let transform = CGAffineTransform(scaleX: 0, y: 0)
        pagerView.itemSize = self.pagerView.frame.size.applying(transform)
        pagerView.automaticSlidingInterval = 4.0 - self.pagerView.automaticSlidingInterval
        pagerView.isInfinite = true
    }
    
    func setupCollectionView()  {
        clvContent?.delegate = self
        clvContent?.dataSource = self
    }
    
    func updateUI() {
        setupCollectionView()
    }
}


extension HomeVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (collectionView.frame.size.width - 5) / 2, height: (collectionView.frame.size.height - 5) / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension HomeVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AR_Features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        let cell:HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        
        if let feature:AR_Features = AR_Features(rawValue: row) {
            cell.imgIcon?.image = feature.icon
            cell.lblTitle?.text = feature.name
        }
        
        return cell;
    }
    
}

extension HomeVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if let featureSelect:AR_Features = AR_Features(rawValue: row) {
            switch featureSelect{
            case .AR_Periodic:
                let vc: PeriodicTableVC = .load(SB: .Periodic)
                App().mainVC?.rootNV?.setViewControllers([vc], animated: false)
            case .AR_Reaction:
//                let vc: NotificationListVC = .load(SB: .Reaction)
//                App().rootNV?.pushViewController(vc, animated: true)
                break
            case .AR_ARKit:
//                let vc: EventListVC = .load(SB: .AR)
//                App().rootNV?.pushViewController(vc, animated: true)
                break
            case .AR_Setting:
//                let vc: GroupTenantListVC = .load(SB: .Setting)
//                App().rootNV?.pushViewController(vc, animated: true)
                break
            }
        }
    }
}

extension HomeVC: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return arrBanners.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.image = arrBanners[index]
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        
        return cell
    }
}


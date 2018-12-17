//
//  TabBarTopView.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

struct TabBarItem {
    var title:String?
    var image: UIImage?
    var color: UIColor?
    
    init(_ name:String, _ image: UIImage? = nil, _ color: UIColor? = nil) {
        self.title = name
        self.image = image
        self.color = color
    }
}

protocol TabBarTopViewDelegate {
    func didSelectedTabBarTopItem(tabBarTopItemView:TabBarTopView, indexBarItem: Int)
}

class TabBarTopView: UIView {
    
    
    @IBOutlet weak var clvContent:UICollectionView?
    @IBOutlet weak var vLineColor:UIView?
    @IBOutlet weak var conLeftvLineColor:NSLayoutConstraint?
    @IBOutlet weak var conWidthvLineColor:NSLayoutConstraint?
    
    fileprivate let tabBarTopIndentifierCell = "TabBarTopViewCell"
    
    var delegate:TabBarTopViewDelegate?
    
    var indexSelected = 0
    
    var tabBarTopItems:[TabBarItem]!{
        didSet{
            setupViewColorSelect()
            clvContent?.reloadData()
        }
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView()  {
        clvContent?.delegate = self;
        clvContent?.dataSource = self;
        
        clvContent?.register(UINib.init(nibName: ClassName(TabBarTopViewCell()), bundle: nil), forCellWithReuseIdentifier: tabBarTopIndentifierCell)
    }
    
    func setupViewColorSelect() {
        conWidthvLineColor?.constant = self.frame.size.width / CGFloat(tabBarTopItems.count)
    }
    
}

extension TabBarTopView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / CGFloat(tabBarTopItems.count), height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


//MARK: - UICollectionViewDataSource
extension TabBarTopView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabBarTopItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let row = indexPath.row;
        let cell:TabBarTopViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: tabBarTopIndentifierCell, for: indexPath) as! TabBarTopViewCell
        
        if let barItems = self.tabBarTopItems{
            let barItem = barItems[row];
            
            cell.lblTitle?.text = barItem.title
            cell.imgIcon?.image = barItem.image
            
            if row == indexSelected{
                cell.lblTitle?.textColor = barItem.color
                cell.lblTitle?.font = AppFont.helveticaBold(with: 14)
                cell.imgIcon?.tintColor = barItem.color
            }else {
                cell.lblTitle?.textColor = AppColor.titleTabColor
                cell.lblTitle?.font = AppFont.helveticaRegular(with: 14)
                cell.imgIcon?.tintColor = AppColor.titleTabColor
            }
        }
        
        return cell;
    }
    
}


//MARK: - UICollectionViewDelegate
extension TabBarTopView:UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexSelected = indexPath.row
        updateContraintViewSelectedEndDecelerating()
        clvContent?.reloadData()
        delegate?.didSelectedTabBarTopItem(tabBarTopItemView: self, indexBarItem: indexSelected)
    }
}


//MARK: - OtherFuntion
extension TabBarTopView {
    func updateContraintViewSelectedDidScroll(_ scrollView:UIScrollView) {
        let width = self.frame.size.width
        let contentOffsetX = scrollView.contentOffset.x;
        
        conLeftvLineColor?.constant = ((contentOffsetX / width) * width ) / CGFloat(tabBarTopItems.count)
        if conLeftvLineColor?.constant ?? 0 > width / 2 {
            vLineColor?.backgroundColor = AppColor.purpleColor
        } else {
            vLineColor?.backgroundColor = AppColor.mainColor
        }
    }
    
    func updateContraintViewSelectedEndDecelerating(){
        let width = self.frame.size.width
        conLeftvLineColor?.constant = (CGFloat(indexSelected) * width ) / CGFloat(tabBarTopItems.count)
        if conLeftvLineColor?.constant ?? 0 > width / 2 {
            vLineColor?.backgroundColor = AppColor.purpleColor
        } else {
            vLineColor?.backgroundColor = AppColor.mainColor
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView:UIScrollView) {
        let contentOffsetX = scrollView.contentOffset.x;
        let width = self.frame.size.width
        indexSelected = Int(contentOffsetX / width);
        clvContent?.reloadData()
    }
}

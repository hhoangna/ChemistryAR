//
//  TabBarBottomView.swift
//  ChemistryAR
//
//  Created by Admin on 10/3/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

import UIKit

struct BarBottomItem {
    var icon:UIImage?
    var name:String?
    var select:Bool?
    var iconSelected: UIImage?

    init(_ icon:UIImage,_ iconSelected: UIImage, _ select:Bool) {
        self.icon = icon
        self.iconSelected = iconSelected
        self.name = ""
        self.select = select
    }
    
    init(_ icon: UIImage,_ iconSelected: UIImage, _ name: String,_ noti: Int? = nil) {
        self.icon = icon
        self.iconSelected = iconSelected
        self.name = name
    }
}

protocol TabBarBottomViewDelegate {
    func didSelectBarButtomItem(tabbarBottomView:TabBarBottomView, indexBarItem: Int);
}

class TabBarBottomView: UIView {
    
    
    @IBOutlet weak var clvContent:UICollectionView?
    @IBOutlet weak var vContent:UIView?
    
    fileprivate let barButtomIndentifierCell = "TabBarBottomCell"
    
    var delegate:TabBarBottomViewDelegate?
    
    var indexSelected = 2
    var barButtomItems:[BarBottomItem]!{
        didSet{
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
        clvContent?.register(UINib.init(nibName: ClassName(TabBarBottomCell()),
                                        bundle: nil),
                             forCellWithReuseIdentifier: barButtomIndentifierCell)
    }
}

extension TabBarBottomView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width / CGFloat(barButtomItems.count), height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


extension TabBarBottomView: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return barButtomItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let row = indexPath.row;
        let cell:TabBarBottomCell = collectionView.dequeueReusableCell(withReuseIdentifier: barButtomIndentifierCell, for: indexPath) as! TabBarBottomCell
        
        if let barItems = self.barButtomItems{
            let barItem = barItems[row];
            
            cell.lblTitle?.text = barItem.name
            cell.imgIcon?.image = barItem.icon
            cell.imvCheck?.isHidden = false
            
            if row == indexSelected{
                cell.imgIcon?.tintColor = AppColor.selectedIconColor
                cell.imvCheck?.tintColor = AppColor.black
                cell.lblTitle?.textColor = AppColor.selectedIconColor
            }else {
                cell.imgIcon?.tintColor = AppColor.black
                cell.lblTitle?.textColor = AppColor.black
                cell.imvCheck?.tintColor = AppColor.white
            }
        }
        return cell;
    }
}

extension TabBarBottomView: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        indexSelected = row
        clvContent?.reloadData()
        delegate?.didSelectBarButtomItem(tabbarBottomView: self, indexBarItem: row)
    }
}

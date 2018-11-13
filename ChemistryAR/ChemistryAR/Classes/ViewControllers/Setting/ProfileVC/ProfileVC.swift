//
//  ProfileVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    
    enum Row: Int {
        case Avatar = 0
        case Info
        case ChangePass
        case Delete
        
        static let count: Int = {
            var max: Int = 0
            while let _ = Row(rawValue: max) {
                max += 1
            }
            return max
        }()
    }
    
    @IBOutlet weak var tbvContent: UITableView?
    
    fileprivate var indentifyAvatar = "AvatarCell"
    fileprivate var indentifyRow = "RowCell"
    fileprivate var indentifyButton = "ButtonCell"
    fileprivate var indentifyDelete = "DeleteCell"
    
    var userModel: User?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateCustomNavigationBar(.BackOnly, "Profile")
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
}

extension ProfileVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowScreen: Row = Row(rawValue: indexPath.row)!
        switch rowScreen {
        case .Avatar:
            return 150
        case .Info:
            return 200
        case .ChangePass:
            return userModel?._id == Caches().token ? 100 : 0
        case .Delete:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowScreen: Row = Row(rawValue: indexPath.row)!
        switch rowScreen {
        case .Avatar:
            return cellAvatar(tableView, indexPath)
        case .Info:
            return cellInfo(tableView, indexPath)
        case .ChangePass:
            return cellPass(tableView, indexPath)
        case .Delete:
            return cellDelete(tableView, indexPath)
        }
    }
}

extension ProfileVC: UITableViewDelegate {
    
}

extension ProfileVC {
    func cellAvatar(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyAvatar,
                                                 for:indexPath) as! ProfileCell
        
        cell.imgIcon?.setImageWithURL(url: userModel?.imgLink, placeHolderImage: UIImage(named: "ic_User"))
        
        return cell
    }
    
    func cellInfo(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyRow,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblSubtitle?.text = userModel?.name
        cell.lblSubtitle1?.text = userModel?.email
        let dob = Date(timeIntervalSince1970: (userModel?.birthday)!)
        cell.lblSubtitle2?.text = DateFormatter.displayDateShortText.string(from: dob)
        cell.lblSubtitle3?.text = userModel?.address
        
        return cell
    }
    
    func cellPass(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyButton,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblTitle?.text = "Change Password"
        
        return cell
    }
    
    func cellDelete(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyDelete,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblTitle?.text = "Delete Account"
        cell.lblTitle?.textColor = .red
        
        return cell
    }
}

//
//  SettingVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import UserNotifications

class SettingVC: BaseVC {
    
    enum Section: Int {
        case Avatar = 0
        case Setting
        case Developer
        
        static let count: Int = {
            var max: Int = 0
            while let _ = Section(rawValue: max) {
                max += 1
            }
            return max
        }()
    }
    
    @IBOutlet weak var tbvContent: UITableView?
    
    fileprivate var indentifyAvatar = "AvatarCell"
    fileprivate var indentifyTitle = "TitleCell"
    fileprivate var indentifyHeader = "HeaderCell"
    fileprivate var indentifyBlank = "BlankCell"
    
    var arrHeader = ["ACCOUNT".localized, "SETTING".localized, "DEVELOPER".localized, ""]
    var arrSetting = ["Notification".localized, "Language".localized, "About".localized]
    var arrSettingIcon = [#imageLiteral(resourceName: "find_1"), #imageLiteral(resourceName: "ic_Language"), #imageLiteral(resourceName: "ic_aboutUs")]
    var arrDevelop = ["User Management".localized, "Model Management".localized]
    var arrDevelopIcon = [#imageLiteral(resourceName: "ic_listUser"), #imageLiteral(resourceName: "ic_listModel")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnLogoutPressed(_ sender: UIButton) {
        let alert = UIAlertController(style: .actionSheet, title: "", message: "Do you want to logout?".localized)
        alert.addAction(title: "LOGOUT".localized, style: .destructive) { (ok) in
            App().onReLogin()
        }
        alert.addAction(title: "Cancel".localized, style: .cancel)
        alert.show()
    }
    
    func getCountNotify(callback:@escaping (Bool, Int) -> Void) {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            DispatchQueue.main.async {
                
                // User Key
                let user:UserDefaults = UserDefaults.standard
                user.set(notifications.count, forKey: "AppBadge")
                
                callback(true, notifications.count)
            }
        }
    }
}

extension SettingVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let sectionScreen: Section = Section(rawValue: section)!
        switch sectionScreen {
        case .Avatar:
            return 1
        case .Developer:
            return arrDevelop.count
        case .Setting:
            return arrSetting.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell: SettingCell = tableView.dequeueReusableCell(withIdentifier: indentifyHeader) as! SettingCell
        
        cell.lblTitle?.text = arrHeader[section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell: SettingCell = tableView.dequeueReusableCell(withIdentifier: indentifyBlank) as! SettingCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let sectionScreen: Section = Section(rawValue: indexPath.section)!
        switch sectionScreen {
        case .Avatar:
            return 160
        case .Setting:
            return 50
        case .Developer:
            if roleType == .Admin {
                return 50
            } else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let rowScreen: Section = Section(rawValue: section)!
        switch rowScreen {
        case .Avatar:
            return cellAvatar(tableView, indexPath)
        case .Setting:
            return cellSetting(tableView, indexPath)
        case .Developer:
            return cellDeveloper(tableView, indexPath)
        }
    }
}

extension SettingVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let rowScreen: Section = Section(rawValue: section)!
        switch rowScreen {
        case .Avatar:
            let vc: ProfileVC = .load(SB: .Setting)
            vc.mode = .modeView
            vc.userModel = Caches().user
            vc.updateAccountSuccess = {[weak self] (success) in
                self?.tbvContent?.reloadData()}
            self.navigationController?.pushViewController(vc, animated: true)
        case .Setting:
            if indexPath.row == 0 {
                let vc: NotificationVC = .load(SB: .Setting)
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 1 {
                return
            } else {
                let vc: AboutVC = .load(SB: .Setting)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        case .Developer:
            if indexPath.row == 0 {
                let vc: UserListVC = .load(SB: .Setting)
                
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                let vc: ModelListVC = .load(SB: .Setting)
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

//Layout
extension SettingVC {
    
    func cellAvatar(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyAvatar,
                                                 for:indexPath) as! SettingCell
        if !isEmpty(Caches().user.avatar) {
            cell.imgAvatar?.setImageWithURL(url: Caches().user.avatar, placeHolderImage: UIImage(named: "ic_User"))
        } else {
            cell.imgAvatar?.setImage(string: Caches().user.name, color: AppColor.borderColor, circular: true, textAttributes: [NSAttributedString.Key.font: AppFont.helveticaBold(with: 25), NSAttributedString.Key.foregroundColor: AppColor.black])
        }
        cell.lblTitle?.text = Caches().user.name
        cell.lblSubtitle?.text = Caches().user.email
        cell.imgVip?.isHidden = roleType == .User ? true : false
        
        return cell
    }
    
    func cellSetting(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyTitle,
                                                 for:indexPath) as! SettingCell
        cell.imgIcon?.image = arrSettingIcon[indexPath.row]
        cell.lblTitle?.text = arrSetting[indexPath.row]
        if indexPath.row == 0 {
            getCountNotify {(success, count) in
                if count > 0 {
                    cell.btnEdit?.isHidden = false
                    cell.btnEdit?.setTitle(String(format: "%i", count), for: .normal)
                } else {
                    cell.btnEdit?.isHidden = true
                }
            }
        } else {
            cell.btnEdit?.isHidden = true
        }
        
        return cell
    }
    
    func cellDeveloper(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyTitle,
                                                 for:indexPath) as! SettingCell
        cell.imgIcon?.image = arrDevelopIcon[indexPath.row]
        cell.lblTitle?.text = arrDevelop[indexPath.row]
        cell.btnEdit?.isHidden = true
        
        return cell
    }
}

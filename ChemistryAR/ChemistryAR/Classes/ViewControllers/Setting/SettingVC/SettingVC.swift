//
//  SettingVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/10/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

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
    
    var arrHeader = ["ACCOUNT", "SETTING", "DEVELOPER", ""]
    var arrSetting = ["Push Notification", "Language", "About"]
    var arrDevelop = ["User Management", "Element Management"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func btnLogoutPressed(_ sender: UIButton) {
        App().onReLogin()
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
        let sectionScreen: Section = Section(rawValue: section)!
        switch sectionScreen {
        case .Avatar:
            return 1
        default:
            return 40
        }
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
            return 100
        case .Setting, .Developer:
            return 50
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
            break
        case .Setting:
            break
        case .Developer:
            let vc: UserListVC = .load(SB: .Setting)
            
            vc.updateCustomNavigationBar(.BackOnly, "List User")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//Layout
extension SettingVC {
    
    func cellAvatar(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyAvatar,
                                                 for:indexPath) as! SettingCell
        
//        cell.imgAvatar?.setImageWithURL(url: Caches().user?.imgLink, placeHolderImage: UIImage(named: "ic_User"))
        cell.lblTitle?.text = Caches().user.name
        cell.lblSubtitle?.text = Caches().user.email
        
        cell.delegate = self
        
        return cell
    }
    
    func cellSetting(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyTitle,
                                                 for:indexPath) as! SettingCell
        
        cell.lblTitle?.text = arrSetting[indexPath.row]
        
        return cell
    }
    
    func cellDeveloper(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyTitle,
                                                 for:indexPath) as! SettingCell
        
        cell.lblTitle?.text = arrDevelop[indexPath.row]
        
        return cell
    }
}

extension SettingVC: SettingCellDelegate {
    func didSelectChangeMode(cell: SettingCell, btn: UIButton) {
        switch btn.tag {
        case 0:
            let vc: ProfileVC = .load(SB: .Setting)
            vc.userModel = Caches().user
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
}

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
    
    var userModel: UserModel?
    var mode: ModeScreen = .modeView {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.updateCustomNavigationBar(.BackEdit, "Profile")
    }
    
    func updateUI() {
        if mode == .modeEdit {
            self.updateCustomNavigationBar(.BackDone, "Profile")
        } else if mode == .modeNew {
            self.updateCustomNavigationBar(.BackOnly, "Profile")
        } else {
            self.updateCustomNavigationBar(.BackEdit, "Profile")
        }
        
        tbvContent?.reloadData()
    }
    
    func fetchData() {
        App().showLoadingIndicator()
      //  SERVICES().API.getAllElement(callback: <#T##APICallback<[ElementModel]>##APICallback<[ElementModel]>##(APIOutput<[ElementModel], APIError>) -> Void#>)
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
    
    override func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        if mode == .modeView {
            mode = .modeEdit
        } else {
            mode = .modeView
        }
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
            if mode == .modeNew {
                return 0
            } else {
                return 100
            }
        case .Delete:
            if mode == .modeNew {
                return 55
            } else {
                return 0
            }
            
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}

extension ProfileVC {
    func cellAvatar(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyAvatar,
                                                 for:indexPath) as! ProfileCell
        
        cell.imgIcon?.setImageWithURL(url: userModel?.avatar, placeHolderImage: UIImage(named: "ic_User"))
        if mode == .modeEdit {
            cell.btnEdit?.isHidden = false
        } else {
            cell.btnEdit?.isHidden = true
        }
        cell.delegate = self
        
        return cell
    }
    
    func cellInfo(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyRow,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblSubtitle?.text = E(userModel?.name)
        cell.lblSubtitle1?.text = E(userModel?.email)
        if let dob = userModel?.birthday {
            let strinDate = DateFormatter.displayDateShortText.string(from: dob)
            cell.lblSubtitle2?.text = E(strinDate)
        } else {
            cell.lblSubtitle2?.text = "Not submit"
        }
        cell.lblSubtitle3?.text = E(userModel?.address)
        
        if mode == .modeEdit {
            cell.csButtonWidth?.constant = 25
        } else {
            cell.csButtonWidth?.constant = 0
        }
        
        cell.delegate = self
        
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

extension ProfileVC: ProfileCellDelegate {
    func didSelectBtnRight(cell: ProfileCell, btn: UIButton) {
        let indexPath = tbvContent?.indexPath(for: cell)
        let row = indexPath?.row
        let rowScreen: Row = Row(rawValue: row!)!
        switch rowScreen {
        case .Avatar:
            doEditAvatar()
        case .Info:
            let tag = cell.btnEdit?.tag
            if tag == 0 {
                doEditUserName()
            } else if tag == 1 {
                doEditDOB()
            } else {
                doEditAddress()
            }
        default:
            break
        }
    }
    
    func doEditAvatar() {
        
    }
    
    func doEditDOB() {
        
    }
    
    func doEditAddress() {
        
    }
    
    func doEditUserName() {
        
    }
}

//
//  ProfileVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class ProfileVC: BaseVC {
    
    typealias ProfileCallback = (_ success: Bool?) -> Void
    
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
    @IBOutlet weak var vLock: UIView?
    
    fileprivate var indentifyAvatar = "AvatarCell"
    fileprivate var indentifyRow = "RowCell"
    fileprivate var indentifyButton = "ButtonCell"
    fileprivate var indentifyDelete = "DeleteCell"
    
    var userModel: UserModel?
    var userTemple: UserModel?
    var deactiveAccountSuccess: ProfileCallback?
    var updateAccountSuccess: ProfileCallback?
    var activeAccountSuccess: ProfileCallback?
    var mode: ModeScreen? {
        didSet {
            updateUI()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        initData()
    }
    
    func initData() {
        fetchData()
        tbvContent?.addRefreshControl(self, action: #selector(fetchData))
    }
    
    func updateUI() {
        if mode == .modeEdit {
            self.updateCustomNavigationBar(.BackDone, "Profile".localized)
            vLock?.isHidden = true
        } else if mode == .modeNew {
            if Caches().user._id == userModel?._id {
                self.updateCustomNavigationBar(.Logout, "Profile".localized)
                vLock?.isHidden = false
            } else {
                self.updateCustomNavigationBar(.BackOnly, "Profile".localized)
                vLock?.isHidden = true
            }
        } else {
            self.updateCustomNavigationBar(.BackEdit, "Profile".localized)
            vLock?.isHidden = true
        }
        
        tbvContent?.reloadData()
    }
    
    @objc func fetchData() {
        if tbvContent?.isRefreshing() ?? true {
            self.tbvContent?.endRefreshControl()
        }
        App().showLoadingIndicator()
        SERVICES().API.getDetailUser(model: userModel!) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.userModel = obj
                self.userTemple = obj
                self.tbvContent?.reloadData()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        if mode == .modeEdit {
            self.showAlertView("Do you want to update your change?".localized, positiveTitle: "Update".localized, positiveAction: { (ok) in
                self.updateAccount()
            }, negativeTitle: "Discard".localized) { (cancel) in
                self.didSelectback()
            }
        } else {
            self.didSelectback()
        }
    }
    
    override func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        if mode == .modeView {
            mode = .modeEdit
        } else if mode == .modeEdit {
            updateAccount()
            mode = .modeView
        } else {
            App().onReLogin()
        }
    }
    
    func updateAccount() {
        App().showLoadingIndicator()
        SERVICES().API.updateDetailUser(model: userModel!) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.showAlertView("Update successfully".localized, positiveTitle: "OK".localized, positiveAction: { (ok) in
                    self.userModel = obj
                    Caches().user = obj
                    self.updateAccountSuccess!(true)
                    self.tbvContent?.reloadData()
                })
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    @IBAction func btnRequestPressed(_ sender: UIButton) {
        App().showLoadingIndicator()
        SERVICES().API.requestActive { (results) in
            App().dismissLoadingIndicator()
            switch results {
            case .object(_ ):
                self.showAlertView("Your request have been sent".localized)
            case .error(_ ):
                self.showAlertView("Unknown error".localized)
            }
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
            if mode == .modeNew && Caches().user._id != userModel?._id {
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
        let rowScreen: Row = Row(rawValue: indexPath.row)!
        switch rowScreen {
        case .ChangePass:
            let vc: ChangePassVC = .load(SB: .Setting)
            self.navigationController?.pushViewController(vc, animated: true)
        case .Delete:
            if userModel?.active ?? true {
                doDeactiveAccount()
            } else {
                doActiveAccount()
            }
        default:
            break
        }
    }
    
    func doActiveAccount() {
        App().showLoadingIndicator()
        userModel?.active = true
        SERVICES().API.activeUser(model: userModel!) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(_ ):
                self.activeAccountSuccess!(true)
                self.didSelectback()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    func doDeactiveAccount() {
        App().showLoadingIndicator()
        SERVICES().API.deactiveUser(model: userModel!) { (result) in
            App().dismissLoadingIndicator()
            switch result {
            case .object(_ ):
                self.deactiveAccountSuccess!(true)
                self.didSelectback()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
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
        cell.imgVip?.isHidden = userModel?.role == "user" ? true : false
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
            cell.lblSubtitle2?.text = "Not submit".localized
        }
        cell.lblSubtitle3?.text = E(userModel?.address)
        
        if mode == .modeEdit {
            cell.csButtonWidth?.constant = 20
        } else {
            cell.csButtonWidth?.constant = 0
        }
        
        cell.delegate = self
        
        return cell
    }
    
    func cellPass(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyButton,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblTitle?.text = "Change Password".localized
        
        return cell
    }
    
    func cellDelete(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyDelete,
                                                 for:indexPath) as! ProfileCell
        
        cell.lblTitle?.text = userModel?.active ?? true ? "Deactive Account".localized : "Active Account".localized
        cell.lblTitle?.textColor = userModel?.active ?? true ? .red : AppColor.mainColor
        
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
            let tag = btn.tag
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
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func doEditDOB() {
        UIAlertController.showDatePicker(style: .actionSheet,
                                         mode: .date,
                                         title: "Select date".localized,
                                         currentDate: userModel?.birthday,
                                         maximumDate:Date()) {[weak self] (date) in
                                            self?.userModel?.birthday = date
                                            self?.tbvContent?.reloadData()
        }
    }
    
    func doEditAddress() {
        let alert = UIAlertController(style: .alert,title: "Change Address".localized)
        alert.showTextViewInput(placeholder: "Enter Address".localized, oldText: E(userModel?.address)) { (ok, content) in
            if !isEmpty(content) {
                self.userModel?.address = content
                self.tbvContent?.reloadData()
            }
        }
    }
    
    func doEditUserName() {
        let alert = UIAlertController(style: .alert,title: "Change Username".localized)
        alert.showTextViewInput(placeholder: "Enter Username".localized, oldText: E(userModel?.name)) { (ok, content) in
            if !isEmpty(content) {
                self.userModel?.name = content
                self.tbvContent?.reloadData()
            }
        }
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            selectedImage = editedImage
            print("editedImage's size = \(editedImage.size)")
            
        } else if let originImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage = originImage
            print("originImage's size = \(originImage.size)")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

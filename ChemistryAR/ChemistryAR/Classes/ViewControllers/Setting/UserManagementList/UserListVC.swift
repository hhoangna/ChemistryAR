//
//  UserListVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

class UserListVC: BaseVC {
    
    @IBOutlet weak var tbvContent: UITableView?
    
    fileprivate var indentifyUser = "UserCell"
    fileprivate var indentifyBlank = "BlankCell"
    
    var arrUser: [UserModel]?
    var arrDisplay: [UserModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        updateCustomNavigationBar(.BackOnly, "User Management".localized)
    }
    
    func initData() {
        getAllUser()
        tbvContent?.addRefreshControl(self, action: #selector(getAllUser))
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
    
    @objc func getAllUser() {
        App().showLoadingIndicator()
        SERVICES().API.getAllUser { (result) in
            if self.tbvContent?.isRefreshing() ?? true {
                self.tbvContent?.endRefreshControl()
            }
            App().dismissLoadingIndicator()
            switch result {
            case .object(let obj):
                self.arrUser = obj
                self.filterListUser(list: obj)
                self.tbvContent?.reloadData()
            case .error(let err):
                self.showAlertView(E(err.message))
            }
        }
    }
    
    func filterListUser(list: [UserModel]?) {
        arrDisplay = list?.filter { (user) -> Bool in
            return user._id != Caches().user._id
        }
        if (self.arrDisplay?.count ?? 0 > 0){
            UIView.removeViewNoItemAtParentView(self.tbvContent!)
        }else {
            UIView.addViewNoItemWithTitle("No Users".localized, intoParentView: self.tbvContent!)
        }
    }
}

extension UserListVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDisplay?.count ?? 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellUser(tableView, indexPath)
    }
}

extension UserListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let vc: ProfileVC = .load(SB: .Setting)

        if let user = arrDisplay?[row] {
            vc.userModel = user
        }
        vc.mode = .modeNew
        vc.deactiveAccountSuccess = {[weak self] (success) in
            self?.getAllUser()
        }
        vc.activeAccountSuccess = {[weak self] (success) in
            self?.getAllUser()
        }

        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//Layout
extension UserListVC {

    func cellUser(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
        let row = indexPath.row

        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyUser,
                                                 for:indexPath) as! UserListCell

        let user = arrDisplay?[row]
        if let url = user?.avatar {
            cell.imgIcon?.setImageWithURL(url: url, placeHolderImage: UIImage(named: "ic_User"))
        } else {
            cell.imgIcon?.setImage(string: user?.name, color: AppColor.borderColor, circular: true, textAttributes: [NSAttributedString.Key.font: AppFont.helveticaBold(with: 18), NSAttributedString.Key.foregroundColor: AppColor.black])
        }
        cell.lblTitle?.text = user?.name
        cell.lblSubtitle?.text = user?.email
        cell.imgVip?.isHidden = user?.role == "user" ? true : false
        if user?.active ?? true {
            cell.lblSubtitle1?.text = SF((user?.dateOffline!)! > 1 ? "%i days ago".localized : "%i day ago".localized, para: user?.dateOffline)
            cell.vContent?.backgroundColor = .white
            cell.lblSubtitle1?.textColor = .black
        } else {
            cell.lblSubtitle1?.text = "Deactived".localized
            cell.lblSubtitle1?.textColor = .red
            cell.vContent?.backgroundColor = .lightGray
        }

        return cell
    }
}

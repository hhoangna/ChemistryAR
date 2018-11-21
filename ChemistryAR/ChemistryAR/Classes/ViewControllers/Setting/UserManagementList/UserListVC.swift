//
//  UserListVC.swift
//  ChemistryAR
//
//  Created by Admin on 10/31/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import FirebaseFirestore
import ObjectMapper

class UserListVC: BaseVC {
    
    @IBOutlet weak var tbvContent: UITableView?
    
    fileprivate var indentifyUser = "UserCell"
    fileprivate var indentifyBlank = "BlankCell"
    
    var db = Firestore.firestore()
    var arrUser: [UserModel]?
    var arrDisplay: [UserModel]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initData()
        updateCustomNavigationBar(.BackOnly, "List User")

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
        vc.deleteAccountSuccess = {[weak self] (success) in
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
        cell.imgIcon?.setImageWithURL(url: user?.avatar, placeHolderImage: UIImage(named: "ic_User"))
        cell.lblTitle?.text = user?.name
        cell.lblSubtitle?.text = user?.email
        cell.imgVip?.isHidden = user?.role == "user" ? true : false
        cell.lblSubtitle1?.text = SF((user?.dateOffline!)! > 1 ? "%i days ago" : "%i day ago", para: user?.dateOffline)

        return cell
    }
}

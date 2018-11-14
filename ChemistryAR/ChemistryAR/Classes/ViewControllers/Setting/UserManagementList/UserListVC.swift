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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        getAllUser()
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        self.didSelectback()
    }
    
//    func getAllUser() {
//        App().showLoadingIndicator()
//        db.collection("Users").getDocuments { (snapshot, error) in
//            App().dismissLoadingIndicator()
//            if let err = error {
//                print("Error getting documents: \(err)")
//            } else {
//                if let user = snapshot?.documents.compactMap({ (document) in
//                    document.data().flatMap({ (data) in
//                        return Mapper<UserModel>().map(JSON: data)
//                    })
//                }) {
//                    self.arrUser = user
//                    self.tbvContent?.reloadData()
//                }
//            }
//        }
//    }
}

//extension UserListVC: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrUser?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 150
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return cellUser(tableView, indexPath)
//    }
//}
//
//extension UserListVC: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let row = indexPath.row
//        let vc: ProfileVC = .load(SB: .Setting)
//
//        if let user = arrUser?[row].user {
//            vc.userModel = user
//        }
//
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
//
////Layout
//extension UserListVC {
//
//    func cellUser(_ tableView:UITableView,_ indexPath:IndexPath) -> UITableViewCell {
//        let row = indexPath.row
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: indentifyUser,
//                                                 for:indexPath) as! UserListCell
//
//        let user = arrUser?[row].user
//        cell.lblTitle?.text = user?.name
//        cell.lblSubtitle?.text = user?.email
//
//        return cell
//    }
//}

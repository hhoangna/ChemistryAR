//
//  NotificationVC.swift
//  ChemistryAR
//
//  Created by Admin on 12/12/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationVC: BaseVC {
    
    @IBOutlet weak var tbvContent: UITableView?

    var arrDisplay: [NotificationModel] = []
    var arrNotifications: [UNNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.updateCustomNavigationBar(.BackDelete, "Notification".localized)
        getAllMyNotifications()
    }
    
    func setupTableView() {
        tbvContent?.delegate = self
        tbvContent?.dataSource = self
        tbvContent?.addRefreshControl(self, action: #selector(onPullRefresh))
    }
    
    override func onNavigationBack(_ sender: UIBarButtonItem) {
        didSelectback()
    }
    
    override func onNavigationClickRightButton(_ sender: UIBarButtonItem) {
        self.showAlertView("Clear All Notifications?".localized,
                           positiveTitle: "OK".localized,
                           positiveAction: { (ok) in
                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                            App().refreshBadgeIconNumber()
                            App().settingVC?.tbvContent?.reloadData()
                            self.onPullRefresh()
        
        }, negativeTitle: "Cancel".localized) { (cancel) in
            //
        }
    }
    
    func getAllMyNotifications()  {
        DispatchQueue.main.async {
            App().showLoadingIndicator()
        }
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            self.arrNotifications = notifications
            DispatchQueue.main.async {
                App().dismissLoadingIndicator()
                if (self.arrNotifications.count > 0){
                    UIView.removeViewNoItemAtParentView(self.tbvContent!)
                }else {
                    UIView.addViewNoItemWithTitle("No Notifications".localized, intoParentView: self.tbvContent!)
                }
                self.tbvContent?.reloadData()
            }
        }
    }
    
    func fetchData() {
        arrDisplay = []
        arrNotifications.forEach { (notification) in
            let content:UNNotificationContent = notification.request.content
            let title = content.title
            if let userInfo:ResponseDictionary = content.userInfo as? ResponseDictionary{
                let noti = NotificationModel()
                if let screen = (userInfo["screen"] as? String)?.data(using: String.Encoding.utf8) {
                    noti.setupWithData(screen)
                    noti.title = title
                    noti.body = content.body;
                    noti.notifyDate = notification.date;
                    
                }else if let screen = (userInfo["screen"] as? ResponseDictionary) {
                    
                    do {
                        let data =  try JSONSerialization.data(withJSONObject: screen, options: JSONSerialization.WritingOptions.prettyPrinted)
                        noti.setupWithData(data)
                        noti.title = title
                        noti.body = content.body;
                        noti.notifyDate = notification.date;
                        
                    }catch (let error){
                        print("Error: \(error)")
                    }
                }
                arrContent.append(noti)
            }
        }
        
        DispatchQueue.main.async {
            App().dismissLoadingIndicator()
            self.tbvContent?.endRefreshControl()
            self.vAction?.isHidden = !(self.arrContent.count > 0)
            if (self.arrContent.count > 0){
                UIView.removeViewNoItemAtParentView(self.tbvContent!)
            }else {
                UIView.addViewNoItemWithTitle("No data".localized, intoParentView: self.tbvContent!)
            }
            self.tbvContent?.reloadData()
        }
    }
    
    @objc func onPullRefresh() {
        getAllMyNotifications()
    }
}

extension NotificationVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell
        if (arrNotifications.count != 0) {
            let dto = arrNotifications[indexPath.row]
            
            cell.lblTitle?.text = dto.request.content.body
            
            let now = Date()
            cell.lblSubtitle?.text = now.offsetLong(from: dto.date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            App().removeReadNotification(notification: arrNotifications[indexPath.row].request)
            self.onPullRefresh()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noti = arrNotifications[indexPath.row]
        
        noti.request.content.userInfo["aps"]
//        NotificationScreenModel.getVCFromScreenDto(notiData: noti) { (fetchSuccess, vc)  in
//            if fetchSuccess{
//                DispatchQueue.main.async {
//                    App().rootNV?.pushViewController(vc, animated: false)
//                    App().removeReadNotification(notification: self.arrHistoryNotifications[indexPath.row].request)
//                    self.onPullRefresh()
//                }
//            }
//        }
        
    }
}

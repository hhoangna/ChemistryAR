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
            self.fetchData()
        }
    }
    
    func fetchData() {
        arrDisplay = []
        arrNotifications.forEach { (notification) in
            let content:UNNotificationContent = notification.request.content
            let title = content.title
            if let userInfo:ResponseDictionary = content.userInfo as? ResponseDictionary{
                let noti = NotificationModel()
                noti.identify = userInfo["identify"] as? String
                noti.desc = userInfo["desc"] as? String
                noti.title = title
                noti.body = content.body;
                noti.date = notification.date;
                arrDisplay.append(noti)
            }
        }
        
        DispatchQueue.main.async {
            App().dismissLoadingIndicator()
            self.tbvContent?.endRefreshControl()
            if (self.arrDisplay.count > 0){
                UIView.removeViewNoItemAtParentView(self.tbvContent!)
            }else {
                UIView.addViewNoItemWithTitle("No Notifications".localized, intoParentView: self.tbvContent!)
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
        return arrDisplay.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NotificationCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NotificationCell
        if (arrDisplay.count != 0) {
            let dto = arrDisplay[indexPath.row]
            
            cell.lblTitle?.text = dto.title
            cell.lblSubtitle1?.text = dto.body
            
            let now = Date()
            cell.lblSubtitle?.text = now.offsetLong(from: dto.date!)
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
        let noti = arrDisplay[indexPath.row]
        
        NotificationModel.getVCFrom(notiData: noti) { (fetchSuccess, vc)  in
            if fetchSuccess{
                DispatchQueue.main.async {
                    App().rootNV?.pushViewController(vc, animated: true)
                    App().removeReadNotification(notification: self.arrNotifications[indexPath.row].request)
                    self.onPullRefresh()
                }
            }
        }
    }
}

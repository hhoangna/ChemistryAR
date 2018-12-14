//
//  NotificationModel.swift
//  ChemistryAR
//
//  Created by Admin on 12/13/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

typealias NotificationScreenCallback = ((_ success: Bool, _ vc: BaseVC) -> Void)

class NotificationModel: BaseModel, Codable {
    
    enum NotificationType: String {
        case Request = "request"
        case Lock = "lock"
        case Unlock = "unlock"
        case Reminder = "reminder"
    }
    
    var identify: String?
    var title: String?
    var body: String?
    var date: Date?
    var desc: String?
    
    class func getVCFrom(notiData:NotificationModel,
                                   callback: NotificationScreenCallback) {
        
        if let identify = notiData.identify{
            if let pushScreen = NotificationType(rawValue: identify) {
                switch pushScreen{
                    
                case .Request:
                    let dto = UserModel()
                    dto._id = notiData.desc
                    let vc: ProfileVC = .load(SB: .Setting)
                    vc.mode = .modeNew
                    vc.userModel = dto
                    callback(true , vc);
                case .Lock, .Unlock:
                    App().onReLogin()
                default:
                    break
                }
            }
        }
    }
}

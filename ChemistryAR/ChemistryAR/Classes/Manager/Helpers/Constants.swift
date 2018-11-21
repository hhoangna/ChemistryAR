//
//  Constants.swift
//  ChemistryAR
//
//  Created by Admin on 10/2/18.
//  Copyright © 2018 HHumorous. All rights reserved.
//

import UIKit

func App() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate;
}

func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: height)
}

func E(_ val: String?) -> String {
    return (val != nil) ? val! : "";
}

func SF(_ val: String?, para:CVarArg? = nil) -> String{
    return String(format: val!, para!)
}

func isEmpty(_ val: String?) -> Bool {
    return val == nil ? true : val!.isEmpty;
}

func ClassName(_ object: Any) -> String {
    return String(describing: type(of: object))
}

func MURL(_ server: String, _ path: String) -> String{
    return server.appending(path);
}

func ToString(_ data: Any) -> String{
    return String(describing: data);
}

func URLENCODE(_ str: String) -> String{
    return str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? str;
}

func URLDECODE(_ str: String) -> String{
    return str.removingPercentEncoding ?? str;
}

func VCFromSB<T>( SB:SBName) -> T {
    return UIStoryboard(name: SB.rawValue,
                        bundle: nil)
        .instantiateViewController(withIdentifier: String(describing: T.self)) as! T;
}

func VCFromSB<T>(_ viewController:T, SB:SBName) -> T {
    return UIStoryboard(name: SB.rawValue,
                        bundle: nil)
        .instantiateViewController(withIdentifier: ClassName(viewController)) as! T;
}

func MAX<T>(_ x: T, _ y: T) -> T where T : Comparable {
    return x > y ? x : y
}

func MIN<T>(_ x: T, _ y: T) -> T where T : Comparable {
    return x < y ? x : y
}

func ABS<T>(_ x: T) -> T where T : Comparable, T : SignedNumeric {
    return x < 0 ? -x : x
}

/// Network constants
struct Network {
    static let googleAPIKey = "AIzaSyDXCigMmInLjLSiEoXRIBaS3teaFHiwtqs"
    static let registerAccountURL      = "https://t4l.seldatdirect.com/#/home"
    
    static let success: Int = 200
    static let unauthorized: Int = 401
    static let loginOtherPlace: Int = 406
}

/// Fonts
struct AppFont {
    static func helveticaRegular(with size: Int) -> UIFont {
        let font = UIFont(name: "Helvetica", size: CGFloat(size))
        
        return font!
    }
    
    static func helveticaBold(with size: Int) -> UIFont {
        let font = UIFont(name: "Helvetica-Bold", size: CGFloat(size))
        
        return font!
    }
}

/// Constants
struct Constants {
    static let isLeftToRight = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
    static let toolbarHeight: CGFloat = 44.0
    static let pickerViewHeight: CGFloat = 216.0
    static let maxSizeForImageUploading = 500000
    static let messageTabIndex: Int = 3
    static let packageTabIndex: Int = 1
    
    static let refreshTimeInterval: Double = 15
    
    static let NAVIGATION_BAR_HEIGHT: CGFloat = 64.0
    static let SCALE_VALUE_HEIGHT_DEVICE: CGFloat = ScreenSize.SCREEN_HEIGHT/768.0
    static let SCALE_VALUE_WIDTH_DEVICE: CGFloat  = ScreenSize.SCREEN_WIDTH/1024
    
    static let FONT_SCALE_VALUE: CGFloat       = ScreenSize.SCREEN_HEIGHT/768.0
    
    static let RATIO_WIDTH               = ScreenSize.SCREEN_WIDTH/1024
    static let RATIO_HEIGHT              = ScreenSize.SCREEN_HEIGHT/768.0
    
    static let REQUEST_LOCATION_INTERVAL: Double = 60.0
    static let ROUTE_WIDTH: CGFloat              = 3.0
}

/// Colors
struct AppColor {
    static let mainColor            = UIColor(hex: "#1B8FFD")
    static let titleTabColor        = UIColor(hex: "#414B5B")
    static let grayColor            = UIColor(hex: "#8F99A4")
    static let white                = UIColor.white
    static let black                = UIColor.black
    static let borderColor          = UIColor(hex: "#C2C2C2")
    static let selectedIconColor    = UIColor(hex: "#D1890C")
    static let blueColor            = UIColor(hex: "#287AFF")
    static let lightBlueColor       = UIColor(hex: "#72A8FF")
    static let yellowColor          = UIColor(hex: "#FFD016")
    static let brownColor           = UIColor(hex: "#7C630D")
    static let lightYellowColor     = UIColor(hex: "#FFFD89")
    static let greenColor           = UIColor(hex: "#15B227")
}

struct Platform {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }()
}

enum RoleType: String {
    case User = "user"
    case Vip = "vip"
    case Admin = "admin"
}

enum ModeScreen: Int {
    case modeNew = 0;
    case modeEdit = 1;
    case modeView = 2;
}

enum ModeBottomBar: Int {
    case modeList = 0
    case modeMain
}

//MARK: - SERVER_URL
struct SERVER_URL {

    static var API: String{
        get{
            return PATH_REQUEST_URL.BASE_URL.URL
        }
    }

    static var API_FILE:String  {
        get{
            return PATH_REQUEST_URL.BASE_URL.URL
        }
    }
}

// Window size
struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

// Device type
struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH <= 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_X          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
}

struct USER_DEFAULT_KEY {
    static let HF_TOKEN_USER = "HF_TOKEN_USER"
    static let HF_FCM_TOKEN = "HF_FCM_TOKEN"
    static let HF_DEVICE_TOKEN = "HF_DEVICE_TOKEN"
    static let HF_REMEBER = "HF_REMEBER"
    static let HF_USER = "HF_USER"
}

struct NotificationName {
    static let shouldUpdateMessageNumbers = "shouldUpdateMessageNumbers"
}

struct SegueIdentifier {
    static let showHome = "showHomeSegue"
    static let showOrderDetail = "orderDetailSegue"
    static let showMapView = "showMapView"
    static let showReasonList = "showReasonList"
    static let showScanBarCode = "showScanBarCode"
}

public enum SBName : String {
    case Main = "Main";
    case Login = "Login";
    case Common = "Common";
    case Home = "Home"
    case Periodic = "Periodic"
    case Reaction = "Reaction"
    case Setting = "Setting"
    case AR = "ARKit"
};


//func ImagePicker() -> ImagePickerView {
//    return ImagePickerView.shared()
//}
//
func Caches() -> Cache {
    return Cache.shared
}
//
//func DataLocal() -> LocalData {
//    return LocalData.shared
//}

typealias ResponseDictionary = [String: Any]
typealias ResponseArray = [Any]

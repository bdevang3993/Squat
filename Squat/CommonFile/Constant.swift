//
//  Constant.swift
//  AllInOneTravels
//
//  Created by devang bhavsar on 07/12/21.
//

import Foundation
import UIKit
//import CoreLocation

//MARK:- Screen Resolution
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let MainStoryBoard = "Main"
let InvitationStoryBoard = "Invitation"
var userId:String = "1"
var strBirthDate:String = ""
var strNewName:String = ""
var strOldName:String = ""
//var personId:String = "2"
var phoneNumber:String = ""
var emailId:String = ""
var cornderRadious:CGFloat = 40.0
var dateCorenerRadious:CGFloat = 10.0
var isPackageSelected:Bool = false
var strSelectedTypeFelt:String = ""
var strSelectedFeeling:String = ""
var strType:String = ""
//var strBackgroundCode:String = "f5f5f5"
var strSelectedLanguage:String = "English"
var strSelectedLocal:String = "en"
var dateSelected:Date?
var isInternalUpdateOfView:Bool = false
var ksimulator = "Simulator"
var historySelectedDate = Date()
var deviceID:String = UIDevice.current.identifierForVendor!.uuidString
var kSelectOption = "please select one option"
var kPleaseAddMember = "please add member from home screen"
var kOptionalDateSelectrion = "please select Date"
var kItemAdded = "You have added Item"
var kother = "other"
var kCustomer = "customer"
var kUpiId = "UpiId"
var kCompanyName = "CompanyName"
var kLogo = "logo"
var kQRCode = "qrCode"
var kTheamColor = "theamColor"
var kSpeach = "speach"
var kNotificationSend = "notificationSend"
var kDate = "Date"
var kMobileDigitAlert = "Mobile number is not more then 12 Digit."
var kFetureAlert = "You can't be select feture date"
var kDataSaveSuccess = "Data save sucessfully"
var kDataUpdate = "Data update successfully"
var kDataDeleted = "Data delete successfully"
var kDatafailedToSave = "Issue in save in database please check again"
var kFetchDataissue = "data can't be find please try again"
var kDeleteData = "data deleted successfully"
var kSelectCustomerData = "please select customer"
var kDeleteMessage = "Are you sure you want to delete?"
var strTheamColor = "#f5f5f5"
var strDescriptionColor = "#C3714B"
var kBackgroundImage = "logo"
var kAppName = "Squat"
var kNumber = "Number"
var kName = "Name"
var kProfileImage = "profileImage"
var kDob = "dob"
var kDod = "dod"
var kAddress = "Address"
var kPassword = "Password"
var kEmailId = "EmailId"
var kLogin = "Login"
var isFromDelete:Bool = false
let kPersistanceStorageName = "Squat"
let kDatabaseName = "PersonProofData"
let kSelectedLanguage = "selectedLanguage"
let kSelectedLocal = "SelectedLocal"
let kUpdateLangauge = "UpdateLangauge"
//MARK:- TypeDefine Declaration
typealias TaSelectedValueSuccess = (String) -> Void
typealias TaSelectedLocalNotification = (String,String) -> Void
typealias TaSelectedPersonInformation = (String,String,String) -> Void
typealias ImagePass = (UIImage) -> Void
typealias TAallImages = ([UIImage]) -> Void
typealias taSelectedFamilyMember = ([FamilyList]) -> Void
typealias taSelectedDetailBesnu = ([ItemList],[FamilyList]) -> Void
//typealias TAallSelectedValues = ([TypeOfSelectionName]) -> Void
typealias updateDataWhenBackClosure = () -> Void
typealias TaSelectedLocationNotification = (Int,String) -> Void
typealias taSelectedIndex = (Int) -> Void
typealias tabuttonCallClouser = () -> Void
typealias taSelectedText = (String,Int) -> Void
typealias taUserCurrentLocation = (Double,Double) -> Void
//typealias taPlaceDetailClosure = (PlaceDetail) -> Void
typealias TaSelectedDate = (Date) -> Void
//MARK:- Constant Struct
typealias reloadTableViewClosure = () -> Void
struct AppMessage {
    var internetIssue:String = "Please check the internet connection"
}
struct AppAlertMessage {
    var oldPassword = "Please provide old password"
    var newPassword = "Please provide new password"
    var confirmPassword = "Please provide confirm password"
    var passwordNotMatch = "password does not match"
    var passwordChageSuccess = "password change successfully"
    var accountMessage = "Your account has been deactivated.please contact to app admin"
}

func setUpBackgroundImage(imageName:String) -> UIImageView {
   // headerViewXib.frame =
    let imageView = UIImageView()
    imageView.frame = CGRect(x: 20, y: (screenHeight / 3 - 38.0), width: (screenWidth - 40.0), height: (screenWidth - 40.0))
    imageView.image = UIImage(named:imageName)
    imageView.contentMode = UIView.ContentMode.scaleAspectFill
    return imageView
}

//MARK:- Convert HexColor To UIColor
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}


//
//  LoginViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 17/02/22.
//

import Foundation
import UIKit

class LoginViewModel: NSObject {
    var objUserInfoDetailQuery = UserInfoDetailQuery()
    var objPersonCardDetail = PersonCardDetail()
    var objPersonFamilyDetail = PersonFamilyDetail()
    var objTerviInfoDetail = TerviInfoDetail()
    var objPersonProofDetail = PersonProofDetail()
    var objPersonInfoDetailQuery = PersonInfoDetailQuery()
    var viewController:UIViewController?
    var arrUserData = [String:Any]()
    var userDefault = UserDefaults.standard
    var updateData:updateDataWhenBackClosure?
    func fetchData(succes SuccessBlock:@escaping ((Bool) -> Void)) {
        objUserInfoDetailQuery.fetchData { (arrData) in
            let email = self.userDefault.value(forKey: kEmailId)
            if email != nil {
                self.userDefault.setValue(self.arrUserData["emailId"] as! String, forKey: kEmailId)
                self.userDefault.setValue(self.arrUserData["mobileNumber"] as! String, forKey: kNumber)
                self.userDefault.setValue(self.arrUserData["password"] as! String, forKey: kPassword)
                self.userDefault.synchronize()
            }
            self.arrUserData = arrData
            SuccessBlock(true)
        } failure: { (isFaied) in
            SuccessBlock(false)
        }
    }
    
    func checkForDataExist(succes successBlock:@escaping(Bool) -> Void)  {
        let userData = objUserInfoDetailQuery.getRecordsCount { (isSuccess) in
            if isSuccess {
                successBlock(true)
            } else {
                successBlock(false)
            }
        }
    }
    func setUpDatabaseForExsitngUser() {
        MBProgressHub.showLoadingSpinner(sender: (viewController?.view)!)
        objUserInfoDetailQuery.saveinDataBase(strName: "Devang", strAddress: "Nadaid", strMobileNumber: "9033356353", strEmailId: "bdevang86@gmail.com", strPassword: "123456", strPhoto: Data()) { (isSuccess) in
            self.setUpDBForPersonInfo()
        }
    }
    func setUpDBForPersonInfo() {
        let image = UIImage(named: "abcd")
        let data = image!.pngData()
        objPersonInfoDetailQuery.saveinDataBase(personid: 0, strName: "Bhavsar Bharatbhai J", strDob: "10/02/1964", strDod: "08/03/2022", personImage: data!, strBesnuAddress: "Arihant Nagar Society, B/H Kidney Hospital Petlad Road, Nadaid", strFirmAddress: "Arihant Nagar Society, B/H Kidney Hospital, Petlad Road, Nadaid", strBesnuDate: "07/03/2022", strBesnuStartTime: "09:30 AM", strBesnuEndTime: "12:30 PM", strMobileNumber: "9033356353", strReferalNumber: "9924872839", strAddressLatitude: 22.69, strAddressLongitude: 72.86) { (isSuccess) in
            self.setUpPersonFamilyInfo()
        }
    }
    func setUpPersonFamilyInfo() {
        objPersonFamilyDetail.saveinDataBase(familyid: 0, personid: 0, strName: "Bhavsar Kishorbhai J", strRelationShip: "Brother") { (isSuccess) in
        }
        objPersonFamilyDetail.saveinDataBase(familyid: 1, personid: 0, strName: "Bhavsar Darshit K", strRelationShip: "Son") { (isSuccess) in
            self.setUpDBForTerviInfo()
        }
    }
    func setUpDBForTerviInfo() {
        objTerviInfoDetail.saveinDataBase(personId: 0, strPersonName: "Bhavsar Bharatbhai J", strDod: "10/02/1964", strMundanDate: "12/03/2022", strTerviDate: "13/03/2022", strMundanStartTime: "06:30 AM", strMundanEndTime: "8:30 AM", strTerviStartTime: "09:30 AM", strTerviEndTime: "12:30 PM", strPlaceName: "OM Santi Hall", strAddress: "Mahagujarat Road, Nadiad", strMobileNumber: "9033356353", strReferealNumber: "9924872839") { (isSuccess) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.updateData!()
        }
    }
}
extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    return true
                }
            }
        if let x = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) {
            if textField.text!.count > 11 {
                Alert().showAlert(message: kMobileDigitAlert, viewController: self)
                return false
            }
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}



//
//  SignUpModel.swift
//  Squat
//
//  Created by devang bhavsar on 17/02/22.
//

import Foundation
struct ItemList {
    var strTitle:String
    var strDescription:String
    var isPicker:Bool = false
    var isEditable:Bool = false
}
enum SignUpDisplayTitle {
    case name,address,mobileNumber,email,password,confirmPassword
    func strSelectedTitle() -> String  {
        switch self {
        case .name:
            return  "Name".localized()
        case .address:
            return "Address".localized()
        case .mobileNumber:
            return "Mobile Number".localized()
        case .email:
            return "Email Id".localized()
        case .password:
            return "Password".localized()
        case .confirmPassword:
            return "Confirm Password".localized()
        default:
            return "Name".localized()
        }
    }
}
enum SelectedViewModel {
    case signUp,detail
    func strSelectedTitle() -> String  {
        switch self {
        case .signUp:
            return "Sign Up".localized()
        case .detail:
            return "Detail".localized()
        }
    }
}

enum PersonDetail {
    case name,dob,dod
    func strSelectedTitle() -> String {
        switch self {
        case .name:
            return "Person Name".localized()
        case .dob:
            return "Date of Birth".localized()
        case .dod:
            return "Date of Death".localized()
        }
    }
}

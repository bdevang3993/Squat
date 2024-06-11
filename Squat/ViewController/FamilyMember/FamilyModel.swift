//
//  FamilyModel.swift
//  Squat
//
//  Created by devang bhavsar on 21/02/22.
//

import Foundation

struct FamilyList {
    var strName:String
    var strRelationShip:String
    var isMatch:Bool = false
}

enum FamilyMemberCategory {
    case father,mother,wife,husband,brother,sisterinLaw,brotherinLaw,sister,son,uncle,aunty,daughter,daughterinLaw,grandDaughteinLaw,greatGrandDaughterinLaw,grandSoninLaw,greatGrandSon
    func selectedString() -> String{
        switch self {
        case .father:
            return "Father".localized()
        case .mother:
            return "Mother".localized()
        case .wife:
            return "Wife".localized()
        case .husband:
            return "Husband".localized()
        case .brother:
            return "Brother".localized()
        case .sisterinLaw:
            return "Sister in Law".localized()
        case .brotherinLaw:
            return "Brother in Law".localized()
        case .sister:
            return "Sister".localized()
        case .son:
            return "Son".localized()
        case .uncle:
            return "Uncle".localized()
        case .aunty:
            return "Aunty".localized()
        case .daughterinLaw:
            return "Daughter in Law".localized()
        case .grandDaughteinLaw:
            return "Grand Daughter in Law".localized()
        case .greatGrandDaughterinLaw:
            return "Great Grand Daughter in Law".localized()
        case .greatGrandSon:
            return "Great Grand Son".localized()
        case .grandSoninLaw:
            return "Grand Son in Law".localized()
        case .daughter:
            return "Daughter".localized()
        default:
            return "Son".localized()
        }
    }
}

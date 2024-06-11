//
//  InvitationModel.swift
//  Squat
//
//  Created by devang bhavsar on 19/02/22.
//

import Foundation
enum InvitationDetail {
    case fullName,dod,besnuDate,startTime,endTime,placeName,address,faimaliyMember,firmAddress,mobileNumber,referalNumber,relationShip,mundanDate,terviDate
    func strSelectedTitle() -> String {
        switch self {
        case .fullName:
            return "Person FullName".localized()
        case .dod:
            return "Date of Passed".localized()
        case .besnuDate:
            return "Besnu Date".localized()
        case .startTime:
            return "Start Time".localized()
        case .endTime:
            return "End Time".localized()
        case .placeName:
            return "Place Name".localized()
        case .address:
            return "Address".localized()
        case .faimaliyMember:
            return "Family Member List".localized()
        case .firmAddress:
            return "Firm Address".localized()
        case .mobileNumber:
            return "Mobile Number".localized()
        case .referalNumber:
            return "Referal Number".localized()
        case .relationShip:
            return "RelationShip".localized()
        case .mundanDate:
            return "Mundan Date".localized()
        case .terviDate:
            return "Tervi Date".localized()
        }
    }
}

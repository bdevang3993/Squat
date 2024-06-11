//
//  AddProofModel.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import Foundation

enum AddRecipe {
    case personName,documentName
    func seletedString() -> String {
        switch self {
        case .personName:
            return "Person Name".localized()
        case .documentName:
            return "Document Name".localized()
        default:
            return "Person Name".localized()
        }
    }
}

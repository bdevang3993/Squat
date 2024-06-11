//
//  PersonInfoModel.swift
//  Squat
//
//  Created by devang bhavsar on 24/02/22.
//

import Foundation
struct PersonInfoDataList {
    var personid:Int
    var strpersonName:String
    var strDob:String
    var strDod:String
    var strPersonImage:Data
    var strBesnuAddress:String
    var strFirmAddress:String
    var strBesnuDate:String
    var strBesnuStartTime:String
    var strBesnuEndTime:String
    var strMobileNumber:String
    var strReferalNumber:String
    var latitude:Double
    var longitude:Double
}

struct TerviInfoDataList {
    var personId: Int
    var personName: String
    var dod: String
    var mundanDate: String
    var terviDate: String
    var mundanStartTime: String
    var mundanEndTime: String
    var terviEndTime: String
    var terviStartTime: String
    var placeName: String
    var address: String
    var mobileNumber: String
    var referalNumber: String
}

struct PersonCardDetailData {
    var personId: Int
    var personName: String
    var besnuCard: String
    var terviCard: String
}

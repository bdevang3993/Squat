//
//  TerviInfo+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 23/02/22.
//
//

import Foundation
import CoreData


extension TerviInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TerviInfo> {
        return NSFetchRequest<TerviInfo>(entityName: "TerviInfo")
    }
    @NSManaged public var personId: Int64
    @NSManaged public var personName: String?
    @NSManaged public var dod: String?
    @NSManaged public var mundanDate: String?
    @NSManaged public var terviDate: String?
    @NSManaged public var mundanStartTime: String?
    @NSManaged public var mundanEndTime: String?
    @NSManaged public var terviEndTime: String?
    @NSManaged public var terviStartTime: String?
    @NSManaged public var placeName: String?
    @NSManaged public var address: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var referalNumber: String?
    
    
}

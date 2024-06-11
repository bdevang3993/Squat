//
//  PersonInfo+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 23/02/22.
//
//

import Foundation
import CoreData


extension PersonInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonInfo> {
        return NSFetchRequest<PersonInfo>(entityName: "PersonInfo")
    }

    @NSManaged public var personName: String?
    @NSManaged public var dob: String?
    @NSManaged public var dod: String?
    @NSManaged public var personImage: Data?
    @NSManaged public var besnuAddress: String?
    @NSManaged public var firmAddress: String?
    @NSManaged public var besnuCardImage: Data?
    @NSManaged public var besnuDate: String?
    @NSManaged public var besnuStartTime: String?
    @NSManaged public var besnuEndTime: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var referalNumber: String?
    @NSManaged public var addressLatitude: Double
    @NSManaged public var addressLongitude: Double
    @NSManaged public var personid: Int64
    

}

//
//  PersonFamilyData+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 23/02/22.
//
//

import Foundation
import CoreData


extension PersonFamilyData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonFamilyData> {
        return NSFetchRequest<PersonFamilyData>(entityName: "PersonFamilyData")
    }
    @NSManaged public var personid: Int64
    @NSManaged public var familyid: Int64
    @NSManaged public var name: String?
    @NSManaged public var relationShip: String?
}

//
//  PersonCardImage+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 24/02/22.
//
//

import Foundation
import CoreData


extension PersonCardImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonCardImage> {
        return NSFetchRequest<PersonCardImage>(entityName: "PersonCardImage")
    }

    @NSManaged public var personId: Int64
    @NSManaged public var personName: String?
    @NSManaged public var besnuCard: String?
    @NSManaged public var terviCard: String?

}

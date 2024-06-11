//
//  ImagesOfBioGraphy+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 22/03/22.
//
//

import Foundation
import CoreData


extension ImagesOfBioGraphy {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImagesOfBioGraphy> {
        return NSFetchRequest<ImagesOfBioGraphy>(entityName: "ImagesOfBioGraphy")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var personId: Int64
    @NSManaged public var placeName: String?

}

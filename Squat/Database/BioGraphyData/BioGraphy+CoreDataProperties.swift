//
//  BioGraphy+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 22/03/22.
//
//

import Foundation
import CoreData


extension BioGraphy {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BioGraphy> {
        return NSFetchRequest<BioGraphy>(entityName: "BioGraphy")
    }
    @NSManaged public var personId: Int64
    @NSManaged public var imageId:Int64
    @NSManaged public var personPlaceName: String?
    @NSManaged public var personDescription: String?
    @NSManaged public var personImage: String?
    @NSManaged public var personName:String?
}

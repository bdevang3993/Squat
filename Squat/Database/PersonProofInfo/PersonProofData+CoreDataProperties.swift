//
//  PersonProofData+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 28/02/22.
//
//

import Foundation
import CoreData


extension PersonProofData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonProofData> {
        return NSFetchRequest<PersonProofData>(entityName: "PersonProofData")
    }

    @NSManaged public var proofImage: Data?
    @NSManaged public var documentName: String?
    @NSManaged public var documentid: Int64
    @NSManaged public var personName: String?

}

//
//  UserInfo+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 23/02/22.
//
//

import Foundation
import CoreData


extension UserInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfo> {
        return NSFetchRequest<UserInfo>(entityName: "UserInfo")
    }

    @NSManaged public var name: String?
    @NSManaged public var address: String?
    @NSManaged public var mobileNumber: String?
    @NSManaged public var emailId: String?
    @NSManaged public var photo: Data?
    @NSManaged public var password: String?

}

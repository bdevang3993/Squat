//
//  FileStoragePath.swift
//  Squat
//
//  Created by devang bhavsar on 23/02/22.
//

import UIKit
import CoreData

final class FileStoragePath: NSObject {
    static var objShared = FileStoragePath()
    private override init() {
    }
    
    func backupDatabase(databaseName:String){
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(databaseName + ".sqlite")
        let container = NSPersistentContainer(name: kPersistanceStorageName)//
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })

        let store:NSPersistentStore
        store = container.persistentStoreCoordinator.persistentStores.last!
        do {
            try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
        } catch {
        }
    }
    
    func convertToJSONArray(moArray: [NSManagedObject]) -> [[String:Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}

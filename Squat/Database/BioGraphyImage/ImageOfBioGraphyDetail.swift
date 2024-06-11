//
//  ImageOfImagesOfBioGraphyDetail.swift
//  Squat
//
//  Created by devang bhavsar on 22/03/22.
//

import Foundation
import CoreData

struct ImageOfBioGraphyDetail {
    var people: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Int) -> Void) )  {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(-1)
                  return
              }
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
              
              //3
              do {
                people = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if people.count > 0 {
           recordBlock(people.count)
        }
        else {
           recordBlock(-1)
        }
    }
    mutating func getImageId(record recordBlock: @escaping ((Int) -> Void) )  {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            recordBlock(-1)
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
        }
        if people.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)
            let data = array.last
            let imageId = data!["imageId"] as! Int
            recordBlock(imageId)
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(personId:Int,imageId:Int,imageURL:String,placeName:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
    
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
               SuccessBlock(false)
              return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "ImagesOfBioGraphy",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(personId, forKeyPath: "personId")
        person.setValue(imageId, forKeyPath: "imageId")
        person.setValue(imageURL, forKey: "imageURL")
        person.setValue(placeName, forKeyPath: "placeName")
        // 4
        do {
            try managedContext.save()
            people.append(person)
            SuccessBlock(true)
        } catch _ as NSError {
           SuccessBlock(false)
        }
    }
    
    
    mutating func fetchData(record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var dicData = [String:Any]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                recordBlock(array)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    mutating func fetchByPersonId(personId:Int,placeName:String,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var dicData = [String:Any]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personId = %ld AND placeName = %@",argumentArray:[personId,placeName] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                recordBlock(array)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
//    mutating func removeImage(imageId:Int,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
//          //1
//          guard let appDelegate =
//            UIApplication.shared.delegate as? AppDelegate else {
//            failureBlock(false)
//            return
//          }
//
//          let managedContext =
//            appDelegate.persistentContainer.viewContext
//
//          //2
//          let fetchRequest =
//            NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
//          fetchRequest.predicate = NSPredicate(format: "imageId = %ld",argumentArray:[imageId] )
//
//          //3
//          do {
//            people = try managedContext.fetch(fetchRequest)
//            if people.count > 0 {
//                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
//                recordBlock(array)
//            } else {
//                failureBlock(false)
//            }
//          } catch _ as NSError {
//            return failureBlock(false)
//          }
//    }
//
    mutating func matchForPersonData(placeName:String,success successBlock:@escaping ([[String:Any]]) -> Void, failed failedBlock:@escaping (Bool) -> Void )  {

          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failedBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "ImagesOfBioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personPlaceName = %@",argumentArray:[placeName] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                if array.count > 0 {
                    successBlock(array)
                }
            } else {
                failedBlock(false)
            }
          } catch _ as NSError {
            return failedBlock(false)
          }
    }
mutating func delete(imageId:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImagesOfBioGraphy")
        fetchRequest.predicate = NSPredicate(format: "imageId = %ld",argumentArray: [Int64(imageId)])
        var result:[NSManagedObject]?
        do {
            result = try context.fetch(fetchRequest) as? [NSManagedObject]
            context.delete(result![0])
        } catch {
        }
        do {
            try context.save()
            successBlock(true)
        }
        catch {
            successBlock(false)
        }
    }
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ImagesOfBioGraphy")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        return true
    }
}

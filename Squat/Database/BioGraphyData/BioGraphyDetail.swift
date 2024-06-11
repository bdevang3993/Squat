//
//  BioGraphyDetail.swift
//  Squat
//
//  Created by devang bhavsar on 22/03/22.
//

import Foundation
import CoreData

struct BioGraphyDetail {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
              
              //3
              do {
                people = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if people.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)
            let id = array.last
            recordBlock(id!["personId"] as! Int)
        }
        else {
           recordBlock(-1)
        }
    }
    

    
    
    
    mutating func saveinDataBase(personId:Int,personPlaceName:String,personDescription:String,personImage:String,personName:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
    
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
            NSEntityDescription.entity(forEntityName: "BioGraphy",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        person.setValue(personId, forKeyPath: "personId")
        person.setValue(personPlaceName, forKey: "personPlaceName")
        person.setValue(personDescription, forKeyPath: "personDescription")
        person.setValue(personImage, forKeyPath: "personImage")
        person.setValue(personName, forKeyPath: "personName")
    
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
            NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
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
    
    mutating func fetchLastPerson(personId:Int,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personId = %ld",argumentArray:[personId] )

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
            NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personId = %ld AND personPlaceName = %@",argumentArray:[personId,placeName] )

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
    mutating func matchPersonName(personName:String,success successBlock:@escaping ([String:Any]) -> Void, failed failedBlock:@escaping (Bool) -> Void )  {

          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failedBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personName = %@",argumentArray:[personName] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                if array.count > 0 {
                    successBlock(array.last!)
                }
            } else {
                failedBlock(false)
            }
          } catch _ as NSError {
            return failedBlock(false)
          }
    }
    
    mutating func matchForPersonData(placeName:String,personName:String,success successBlock:@escaping ([[String:Any]]) -> Void, failed failedBlock:@escaping (Bool) -> Void )  {

          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failedBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BioGraphy")
          fetchRequest.predicate = NSPredicate(format: "personPlaceName = %@ AND personName = %@",argumentArray:[placeName,personName] )

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
    
mutating func delete(personId:Int,personImage:String,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BioGraphy")
        fetchRequest.predicate = NSPredicate(format: "personId = %d AND personImage = %@",argumentArray: [Int64(personId),personImage])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BioGraphy")
        
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

//
//  PersonFamilyDetail.swift
//  Squat
//
//  Created by devang bhavsar on 23/02/22.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct PersonFamilyDetail {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonFamilyData")
              
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
    
    mutating func saveinDataBase(familyid:Int,personid:Int,strName:String,strRelationShip:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
    
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
            NSEntityDescription.entity(forEntityName: "PersonFamilyData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(familyid, forKeyPath: "familyid")
        person.setValue(personid, forKeyPath: "personid")
        person.setValue(strName, forKey: "name")
        person.setValue(strRelationShip, forKeyPath: "relationShip")
        
    
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonFamilyData")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

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
    
    mutating func fetchByPersonId(personid:Int,record recordBlock: @escaping (([[String:Any]]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonFamilyData")
          fetchRequest.predicate = NSPredicate(format: "personid = %@",argumentArray:[personid] )

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
    
    
    mutating func matchForPersonId(personid:Int,success successBlock:@escaping ((Bool) -> Void))  {

          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            successBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PersonFamilyData")
          fetchRequest.predicate = NSPredicate(format: "personid = %ld",argumentArray:[personid] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                if array.count > 0 {
                    successBlock(true)
                }
            } else {
                successBlock(false)
            }
          } catch _ as NSError {
            return successBlock(false)
          }
    }
    
    
    func updateDataBase(strFamilyId:String,besnuCardImage:Data) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonFamilyData")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "familyid = %@",
                                             argumentArray:[strFamilyId] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
         
                results![0].setValue(besnuCardImage, forKey: "besnuCardImage")
            }
        } catch {
        }
        
        do {
            try context.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonFamilyData")
        
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

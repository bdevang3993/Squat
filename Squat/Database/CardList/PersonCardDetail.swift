//
//  PersonCardDetail.swift
//  Squat
//
//  Created by devang bhavsar on 24/02/22.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct PersonCardDetail {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonCardImage")
              
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
    
    mutating func saveinDataBase(personId:Int,strPersonName:String,besnuCard:String,terviCard:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
        
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
            NSEntityDescription.entity(forEntityName: "PersonCardImage",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(personId, forKeyPath: "personId")
        person.setValue(strPersonName, forKeyPath: "personName")
        person.setValue(besnuCard, forKey: "besnuCard")
        person.setValue(terviCard, forKeyPath: "terviCard")
        
    
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonCardImage")
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
    
    
    
    mutating func fetchDataPersonId(personid:Int,record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {

          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PersonCardImage")
          fetchRequest.predicate = NSPredicate(format: "personId = %ld",argumentArray:[personid] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                if array.count > 0 {
                    let dicData = array[0]
                    recordBlock(dicData)
                }
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    
    func updateBesnuCard(personid:Int,besnuCardImage:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCardImage")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "personId = %ld",
                                             argumentArray:[personid] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
         
                results![0].setValue(besnuCardImage, forKey: "besnuCard")
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
    
    func updateTerviCard(personid:Int,terviCard:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCardImage")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "personId = %ld",
                                             argumentArray:[personid] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
         
                results![0].setValue(terviCard, forKey: "terviCard")
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
    
    func delete(id:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCardImage")
        fetchRequest.predicate = NSPredicate(format: "personId = %d",argumentArray: [Int64(id)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonCardImage")
        
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

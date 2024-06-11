//
//  PersonProofDetail.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import Foundation
import Foundation
import CoreData
//MARK:- Database Maintains
struct PersonProofDetail {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonProofData")
              
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
    
    mutating func saveinDataBase(documentId:Int,strDocumentName:String,strPersonName:String,proofImage:Data,success SuccessBlock:@escaping ((Bool) -> Void))  {
        
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
            NSEntityDescription.entity(forEntityName: "PersonProofData",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(documentId, forKeyPath: "documentid")
        person.setValue(strDocumentName, forKeyPath: "documentName")
        person.setValue(strPersonName, forKey: "personName")
        person.setValue(proofImage, forKeyPath: "proofImage")
        
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonProofData")
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
    
    func delete(id:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonProofData")
        fetchRequest.predicate = NSPredicate(format: "documentid = %d",argumentArray: [Int64(id)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonProofData")
        
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

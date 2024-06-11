//
//  UserInfoDetail.swift
//  Squat
//
//  Created by devang bhavsar on 23/02/22.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct UserInfoDetailQuery {
    var people: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Bool) -> Void) )  {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(false)
                  return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
              
              //3
              do {
                people = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if people.count > 0 {
           recordBlock(true)
        }
        else {
           recordBlock(false)
        }
    }
    
    mutating func saveinDataBase(strName:String,strAddress:String,strMobileNumber:String,strEmailId:String,strPassword:String,strPhoto:Data,success SuccessBlock:@escaping ((Bool) -> Void))  {
    
        
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
            NSEntityDescription.entity(forEntityName: "UserInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       
        person.setValue(strName, forKeyPath: "name")
        person.setValue(strAddress, forKey: "address")
        person.setValue(strMobileNumber, forKeyPath: "mobileNumber")
        person.setValue(strEmailId, forKeyPath: "emailId")
        person.setValue(strPassword, forKeyPath: "password")
        person.setValue(strPhoto, forKeyPath: "photo")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
            SuccessBlock(true)
        } catch _ as NSError {
           SuccessBlock(false)
        }
    }
    
    
    mutating func fetchData(record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                dicData = array[0]
            } else {
                recordBlock(dicData)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    mutating func fetchDataByEmail(emailId:String,record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "UserInfo")
            fetchRequest.predicate = NSPredicate(format: "emailId = %@",argumentArray:[emailId])

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                dicData = array[0]
                recordBlock(dicData)
            } else {
                return failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    func updateDataBase(strName:String,strAddress:String,strEmailId:String,strMobileNumber:String,photo:Data) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "emailId = %@",
                                             argumentArray:[strEmailId] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
         
                results![0].setValue(strName, forKeyPath: "name")
                results![0].setValue(strAddress, forKeyPath: "address")
                results![0].setValue(strMobileNumber, forKey: "mobileNumber")
                results![0].setValue(photo, forKey: "photo")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        
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

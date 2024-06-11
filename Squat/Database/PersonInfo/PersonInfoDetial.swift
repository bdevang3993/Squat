//
//  PersonInfoDetial.swift
//  Squat
//
//  Created by devang bhavsar on 23/02/22.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct PersonInfoDetailQuery {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PersonInfo")
              
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
    
    mutating func saveinDataBase(personid:Int,strName:String,strDob:String,strDod:String,personImage:Data,strBesnuAddress:String,strFirmAddress:String,strBesnuDate:String,strBesnuStartTime:String,strBesnuEndTime:String,strMobileNumber:String,strReferalNumber:String,strAddressLatitude:Double,strAddressLongitude:Double,success SuccessBlock:@escaping ((Bool) -> Void))  {
    
        
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
            NSEntityDescription.entity(forEntityName: "PersonInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(personid, forKeyPath: "personid")
        person.setValue(strName, forKey: "personName")
        person.setValue(strDob, forKeyPath: "dob")
        person.setValue(strDod, forKeyPath: "dod")
        person.setValue(personImage, forKeyPath: "personImage")
        person.setValue(strBesnuAddress, forKeyPath: "besnuAddress")
        person.setValue(strFirmAddress, forKeyPath: "firmAddress")
        person.setValue(strBesnuDate, forKeyPath: "besnuDate")
        person.setValue(strBesnuStartTime, forKeyPath: "besnuStartTime")
        person.setValue(strBesnuEndTime, forKeyPath: "besnuEndTime")
        person.setValue(strMobileNumber, forKeyPath: "mobileNumber")
        person.setValue(strReferalNumber, forKeyPath: "referalNumber")
        person.setValue(strAddressLatitude, forKeyPath: "addressLatitude")
        person.setValue(strAddressLongitude, forKeyPath: "addressLongitude")
        
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonInfo")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
               return recordBlock(array)
            } else {
                return failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    mutating func matchDataByName(strPersonName:String,record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonInfo")
          fetchRequest.predicate = NSPredicate(format: "personName = %@",argumentArray:[strPersonName] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                dicData = array[0]
                recordBlock(dicData)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    mutating func fetchDataByPersonId(personid:Int,record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "PersonInfo")
          fetchRequest.predicate = NSPredicate(format: "personid = %ld",argumentArray:[personid] )

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
    
    func updateDataBase(strPersonid:Int,strName:String,strDob:String,strDod:String,personImage:Data,strBesnuAddress:String,strFirmAddress:String,strBesnuDate:String,strBesnuStartTime:String,strBesnuEndTime:String,strMobileNumber:String,strReferalNumber:String,strAddressLatitude:Double,strAddressLongitude:Double,success successBlock:@escaping ((Bool) -> Void))  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonInfo")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "personid = %@",
                                             argumentArray:[strPersonid] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
         
                results![0].setValue(strName, forKey: "personName")
                results![0].setValue(strDob, forKey: "dob")
                results![0].setValue(strDod, forKey: "dod")
                results![0].setValue(personImage, forKey: "personImage")
                results![0].setValue(strBesnuAddress, forKey: "besnuAddress")
                results![0].setValue(strFirmAddress, forKey: "firmAddress")
                results![0].setValue(strBesnuDate, forKey: "besnuDate")
                results![0].setValue(strBesnuStartTime, forKey: "besnuStartTime")
                results![0].setValue(strBesnuEndTime, forKey: "besnuEndTime")
                results![0].setValue(strMobileNumber, forKey: "mobileNumber")
                results![0].setValue(strReferalNumber, forKey: "referalNumber")
                results![0].setValue(strAddressLatitude, forKey: "addressLatitude")
                results![0].setValue(strAddressLongitude, forKey: "addressLongitude")
                
            }
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
    
    func delete(id:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonInfo")
        fetchRequest.predicate = NSPredicate(format: "personid = %d",argumentArray: [Int64(id)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PersonInfo")
        
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

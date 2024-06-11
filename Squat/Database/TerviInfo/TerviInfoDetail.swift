//
//  TerviInfoDetail.swift
//  Squat
//
//  Created by devang bhavsar on 25/02/22.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct TerviInfoDetail {
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TerviInfo")
              
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
    
    mutating func saveinDataBase(personId:Int,strPersonName:String,strDod:String,strMundanDate:String,strTerviDate:String,strMundanStartTime:String,strMundanEndTime:String,strTerviStartTime:String,strTerviEndTime:String,strPlaceName:String,strAddress:String,strMobileNumber:String,strReferealNumber:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
       
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
            NSEntityDescription.entity(forEntityName: "TerviInfo",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(personId, forKeyPath: "personId")
        person.setValue(strPersonName, forKeyPath: "personName")
        person.setValue(strDod, forKeyPath: "dod")
        person.setValue(strMundanDate, forKeyPath: "mundanDate")
        person.setValue(strTerviDate, forKey: "terviDate")
        person.setValue(strMundanStartTime, forKeyPath: "mundanStartTime")
        person.setValue(strMundanEndTime, forKeyPath: "mundanEndTime")
        person.setValue(strTerviStartTime, forKeyPath: "terviStartTime")
        person.setValue(strTerviEndTime, forKeyPath: "terviEndTime")
        person.setValue(strPlaceName, forKeyPath: "placeName")
        person.setValue(strAddress, forKeyPath: "address")
        person.setValue(strMobileNumber, forKeyPath: "mobileNumber")
        person.setValue(strReferealNumber, forKeyPath: "referalNumber")
        
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
            NSFetchRequest<NSManagedObject>(entityName: "TerviInfo")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                recordBlock(array)
            } else {
                return failureBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    mutating func checkDataById(personId:Int,success successBlock:@escaping ((Bool) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "TerviInfo")
            fetchRequest.predicate = NSPredicate(format: "personId = %@",argumentArray:[personId] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                successBlock(true)
            } else {
                successBlock(false)
            }
          } catch _ as NSError {
            return failureBlock(false)
          }
    }
    
    
    mutating func fetchDataByName(name:String,record recordBlock: @escaping (([String:Any]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
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
            NSFetchRequest<NSManagedObject>(entityName: "TerviInfo")
          fetchRequest.predicate = NSPredicate(format: "personName = %@",argumentArray:[name] )

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
    
    func updateDataBase(personId:Int,strDod:String,strMundanDate:String,strTerviDate:String,strMundanStartTime:String,strMundanEndTime:String,strTerviStartTime:String,strTerviEndTime:String,strPlaceName:String,strAddress:String,strMobileNumber:String,strReferalNumber:String,success SuccessBlock:@escaping ((Bool) -> Void))  {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TerviInfo")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "personId = %@",
                                             argumentArray:[personId] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                results![0].setValue(strDod, forKeyPath: "dod")
                results![0].setValue(strMundanDate, forKeyPath: "mundanDate")
                results![0].setValue(strTerviDate, forKeyPath: "terviDate")
                results![0].setValue(strMundanStartTime, forKey: "mundanStartTime")
                results![0].setValue(strMundanEndTime, forKey: "mundanEndTime")
                results![0].setValue(strTerviStartTime, forKeyPath: "terviStartTime")
                results![0].setValue(strTerviEndTime, forKeyPath: "terviEndTime")
                results![0].setValue(strPlaceName, forKey: "placeName")
                results![0].setValue(strAddress, forKey: "address")
                results![0].setValue(strMobileNumber, forKey: "mobileNumber")
                results![0].setValue(strReferalNumber, forKey: "referalNumber")
                
            }
        } catch {
        }
        
        do {
            try context.save()
            SuccessBlock(true)
        }
        catch {
            SuccessBlock(false)
        }
    }
    
    func delete(id:Int,success successBlock:@escaping ((Bool) -> Void)) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TerviInfo")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TerviInfo")
        
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

//
//  CardShowImageViewController.swift
//  Squat
//
//  Created by devang bhavsar on 26/02/22.
//

import UIKit
import CoreData

class CardShowImageViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgDisplay: UIImageView!
    var objCardShowImageViewModel = CardShowImageViewModel()
    var selectedImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isFromSideMenu {
            if isFromDelete {
                imgDisplay.isHidden = true
                MBProgressHub.showLoadingSpinner(sender: self.view)
                self.destroyPersistentStore()
                isFromDelete = false
            } else {
                self.restoreFromStore(backupName: kDatabaseName)
            }
           
        } else {
            objCardShowImageViewModel.setHeaderView(headerView: viewHeader)
            imgDisplay.image = selectedImage
        }
    }
    
    
    func destroyPersistentStore() {
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("\(kDatabaseName).sqlite")
        let filerManager = FileManager.default
        do{
           try filerManager.removeItem(at: storeUrl)
            self.destoryLocalFolder()
        } catch {
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.moveToMainPage()
        }
    }
    
    func destoryLocalFolder() {
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(kDatabaseName + ".sqlite")
        let filerManager1 = FileManager.default
        do{
           try filerManager1.removeItem(at: backupUrl)
        } catch {
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.moveToMainPage()
        }
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores
            let filerManager2 = FileManager.default
            do{
                try filerManager2.removeItem(at: stores[0].url!)
                self.removeImageWithFolder()
            } catch {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.moveToMainPage()
            }
        })
    }
    
    func removeImageWithFolder() {
        DocumentDirectoryAccess.objShared.deleteDirectory()
        MBProgressHub.dismissLoadingSpinner(self.view)
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: kEmailId)
        userDefault.removeObject(forKey: kPassword)
        userDefault.removeObject(forKey: kNumber)
        userDefault.synchronize()
        self.moveToMainPage()
    }
    
    
    func restoreFromStore(backupName: String){
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("\(backupName).sqlite")
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores
            for _ in stores {
            }
            do{
                try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
                self.moveToMainPage()
            } catch {
                self.moveToMainPage()
            }
        })
    }
    func moveToMainPage() {
        DispatchQueue.main.async {
            let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
            self.view.window?.rootViewController = initialViewController
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

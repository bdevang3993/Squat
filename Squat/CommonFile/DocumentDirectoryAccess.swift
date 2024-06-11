//
//  DocumentDirectoryAccess.swift
//  Squat
//
//  Created by devang bhavsar on 26/02/22.
//

import Foundation

final class DocumentDirectoryAccess: NSObject {
    
    static var objShared = DocumentDirectoryAccess()
    private override init() {
    }
    
    func saveImageDocumentDirectory(name:String,imageData:Data){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ImageList/\(name)")
        let image = UIImage(data: imageData)
        print(paths)
        let imageData = image!.pngData()
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    func saveDirectImageDocumentDirectory(name:String,image:UIImage,success successBlock:@escaping(Bool) -> Void){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ImageList/\(name)")
        let imageData = image.pngData()
        successBlock(fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil))
    }
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]; return documentsDirectory
    }
    func getImage(name:String,image imageBlock:((UIImage) -> Void),failed failedBlock:((Bool) -> Void)){
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("ImageList/\(name)")
        if fileManager.fileExists(atPath: imagePAth){
            let image = UIImage(contentsOfFile: imagePAth)
            if image == nil {
                failedBlock(false)
            } else {
                imageBlock(image!)
            }
        }else{
            failedBlock(false)
        }
    }
    func removeImage(name:String,success successBlock:((Bool) -> Void)) {
        let fileManager = FileManager.default
        let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent("ImageList/\(name)")
        if fileManager.fileExists(atPath: imagePAth){
            do {
                try fileManager.removeItem(atPath: imagePAth)
                //try fileManager.removeItem(at: URL(string: imagePAth)!)
            }
            catch {
                successBlock(false)
            }
            successBlock(true)
        }else{
            successBlock(false)
        }
    }
    
    func createDirectory(sucess sucessBlock:((Bool) -> Void)){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ImageList")
        if !fileManager.fileExists(atPath: paths){
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
            sucessBlock(true)
        }else{
            sucessBlock(false)
        }
    }
    
    func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("customDirectory")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            print("Something wronge.")
        }
    }
}



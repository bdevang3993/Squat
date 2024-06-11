//
//  BubleDetailViewModel.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 14/03/22.
//

import UIKit

class BubbleDetailViewModel: NSObject {
    var tableView:UITableView?
    var viewController:UIViewController?
    var arrAllImages = [UIImage]()
    var objImageOfBioGraphyDetail = ImageOfBioGraphyDetail()
    var biographyData = BiographyData(personId: 0, personPlaceName: "", personDescription: "", personImage: "", personName: "")
    var arrAllPersonData = [PersonImage]()
    func fetchAllData() {
        objImageOfBioGraphyDetail.fetchByPersonId(personId: biographyData.personId, placeName: biographyData.personPlaceName) { (result) in
            self.arrAllPersonData.removeAll()
            self.arrAllImages.removeAll()
            for value in result {
                let data = PersonImage(personId: value["personId"] as! Int, imageId: value["imageId"] as! Int, imageURL: value["imageURL"] as! String, placeName: value["placeName"] as! String)
                self.arrAllPersonData.append(data)
                DocumentDirectoryAccess.objShared.getImage(name: value["imageURL"] as! String) { (image) in
                    self.arrAllImages.append(image)
                } failed: { (isFailed) in
                }
            }
            DispatchQueue.main.async {
                self.tableView?.reloadData()
            }
        } failure: { (isFailed) in
            
        }
    }
    func setUpDelete(index:Int) {
        let data = self.arrAllPersonData[index]
        DocumentDirectoryAccess.objShared.removeImage(name: data.imageURL) { (isSuccess) in
            if isSuccess {
                self.objImageOfBioGraphyDetail.delete(imageId: data.imageId) { (isSuccess) in
                    self.arrAllImages.remove(at:index)
                    self.tableView!.reloadData()
                }
                
            } else {
                Alert().showAlert(message: "please check the data".localized(), viewController: viewController!)
            }
        }
    }
    func openImage(index:Int) {
        let objImageDisplay:ImageDisplayViewController = UIStoryboard(name: BiographyStoryBoard, bundle: nil).instantiateViewController(identifier: "ImageDisplayViewController") as! ImageDisplayViewController
        objImageDisplay.modalPresentationStyle = .custom
        objImageDisplay.selectedImage = self.arrAllImages[index]
        viewController!.present(objImageDisplay,animated: true, completion: nil)
    }
}

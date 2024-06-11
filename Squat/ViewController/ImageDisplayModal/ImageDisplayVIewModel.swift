//
//  ImageDisplayVIewModel.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 19/03/22.
//

import UIKit

class ImageDisplayVIewModel: NSObject {
 var objImagePickerViewModel = MultipleImagePickerViewModel()
 var viewController:UIViewController?
 var tableView:UITableView?
    var arrTitle = ["Person Name".localized(),"Place Name".localized(),"Description".localized()]
 var arrDescription = ["","",""]
 var arrAllImages = [UIImage]()
 var headerViewXib:CommanView?
 var objBioGraphyDetail = BioGraphyDetail()
 var objImageOfBioGraphyDetail = ImageOfBioGraphyDetail()
 var personId:Int = -1
 var imageId:Int = -1
 var strPersonName:String = ""
 var dispatchGroup = DispatchGroup()
 var updateDatabase:updateDataWhenBackClosure?
    func setHeaderView(headerView:UIView,strTitle:String) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = strTitle
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ImageDisplayViewController(), action: #selector(ImageDisplayViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.getDocumetDirectory()
    }
    
    func getDocumetDirectory() {
        arrDescription[0] = strPersonName
        DocumentDirectoryAccess.objShared.createDirectory { (isSucces) in
          
        }
        dispatchGroup.enter()
        self.getPersonId()
        dispatchGroup.enter()
        self.getLastImageId()
        dispatchGroup.notify(queue: .main) {
           // Alert().showAlert(message: "All id got", viewController: self.viewController!)
        }
    }
    
    func setUpImagePicker(isFromProfile:Bool,imageView:UIImageView?)  {
        objImagePickerViewModel.viewController = viewController
        objImagePickerViewModel.selectedImage = { [weak self] result in
            if isFromProfile {
                if let image = imageView {
                    image.image = result[0]
                }
            } else {
                self?.arrAllImages = result
            }
            print("All count = \(self?.arrAllImages.count ?? 0)")
            self?.tableView?.reloadData()
        }
        objImagePickerViewModel.presentPicker()
    }
    func getPersonId() {
        objBioGraphyDetail.getRecordsCount { (result) in
            DispatchQueue.main.async {
                self.dispatchGroup.leave()
                self.personId = result + 1
            }
        }
    }
    
    func getLastImageId() {
        objImageOfBioGraphyDetail.getImageId { (result) in
            DispatchQueue.main.async {
                self.dispatchGroup.leave()
                self.imageId = result
            }
        }
    }
    
    func matchData(strPlaceName:String,strDescription:String,image:UIImage)  {
        objBioGraphyDetail.matchForPersonData(placeName: strPlaceName, personName: arrDescription[0].capitalizingFirstLetter()) { (result) in
            let newData = result[0]
            let totalCount = result.count
            self.imageId = totalCount
            if let personId = newData["personId"] {
                self.personId = personId as! Int
            }
            if let descriptionData = newData["personDescription"] {
                self.saveDataInDatabase(strPlaceName: strPlaceName, strDescription: descriptionData as! String, totalCount: totalCount, image: image)
            }
        } failed: { (isFailed) in
            DispatchQueue.main.async {
                self.objBioGraphyDetail.matchPersonName(personName: self.arrDescription[0].capitalizingFirstLetter()) { (result) in
                    self.personId = result["personId"] as! Int
                    self.saveDataInDatabase(strPlaceName: strPlaceName, strDescription: strDescription, totalCount: 0, image: image)

                } failed: { (isFalied) in
                    DispatchQueue.main.async {
                        self.saveDataInDatabase(strPlaceName: strPlaceName, strDescription: strDescription, totalCount: 0, image: image)
                    }
                }
            }
         
        }
    }
    
    func saveImageDataInDatabase(strPlaceName:String,strDescription:String,totalCount:Int) {
        if self.arrAllImages.count <= 0 {
            Alert().showAlert(message: "please select images", viewController: viewController!)
            return
        }
        for i in 0...self.arrAllImages.count - 1 {
            self.imageId = self.imageId + 1
            let name = "\(strPlaceName.capitalizingFirstLetter())\(self.personId)\(self.imageId)"
            DocumentDirectoryAccess.objShared.saveDirectImageDocumentDirectory(name:name , image: self.arrAllImages[i]) { (isSuccess) in
                self.objImageOfBioGraphyDetail.saveinDataBase(personId: self.personId, imageId: self.imageId, imageURL: name, placeName: strPlaceName.capitalizingFirstLetter()) { (isSuccess) in
                    if i == self.arrAllImages.count - 1 {
                        self.updateDatabase!()
                    }
                }
            }
        }
    }
    
    func saveDataInDatabase(strPlaceName:String,strDescription:String,totalCount:Int,image:UIImage) {
        let name = "\(strPlaceName.capitalizingFirstLetter())\(self.personId)\("profile")"
        DocumentDirectoryAccess.objShared.saveDirectImageDocumentDirectory(name:name , image: image) { (isSuccess) in
            DispatchQueue.main.async {
                self.objBioGraphyDetail.saveinDataBase(personId: self.personId, personPlaceName: strPlaceName.capitalizingFirstLetter(), personDescription: strDescription, personImage: name, personName: self.arrDescription[0].capitalizingFirstLetter()) { (isSucess) in
                    DispatchQueue.main.async {
                        self.saveImageDataInDatabase(strPlaceName: strPlaceName, strDescription: strDescription, totalCount: totalCount)
                    }
                }
            }
            
        }
    }
    
    func checkForValidation() -> Bool {
        if self.arrDescription[0].isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + arrTitle[0], viewController: viewController!)
            return false
        }
        if self.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + arrTitle[1], viewController: viewController!)
            return false
        }
        if self.arrDescription[2].isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + arrTitle[2], viewController: viewController!)
            return false
        }
        return true
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int,section:Int) {
        let data = arrTitle[index]
        cell.lblTitle.text = data
        cell.txtDescription.tag = index
        cell.btnCall.isHidden = true
        cell.btnSelection.tag = section
        cell.txtDescription.tag = index
        cell.hideButtonSelection()
        cell.callclicked = {[weak self] value in
            print("selected Value = \(value)")
        }
        cell.selectedText = {[weak self] (value,index) in
            self!.arrDescription[index] = value
        }
        cell.textFieldResign = {[weak self] (index) in
            self?.tableView?.reloadData()
        }
        cell.alertMessage = {[weak self] message in
        }
        cell.selectedIndex = {[weak self] index in
           // self?.setUpRelationPicker(index: index)
        }
    }
}
extension ImageDisplayViewController {
    func setUpHidenImage()  {
        self.imgDisplay.isHidden = true
        self.tblDisplyData.isHidden = true
        self.viewDataSave.isHidden = true
        self.btnSave.isHidden = true
        self.btnImageDisplay.isHidden = true
        self.btnChooseImage.isHidden = true
    }
    func showImageDisplay() {
        self.imgDisplay.isHidden = false
        self.tblDisplyData.isHidden = false
        self.viewDataSave.isHidden = false
        self.btnSave.isHidden = false
        self.btnChooseImage.isHidden = false
    }
}

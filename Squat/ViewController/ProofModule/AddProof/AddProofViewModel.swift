//
//  AddProofViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import UIKit

class AddProofViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var imgSelectedImage:Data?
    var objPersonProofDetail = PersonProofDetail()
    var arrAllItems = [ItemList]()
    var documentId:Int = -1
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Add Proof".localized()
        headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib?.btnBack.addTarget(AddProofViewController(), action: #selector(AddProofViewController.backClicked), for: .touchUpInside)
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func getDocumentId() {
        objPersonProofDetail.getRecordsCount { (totalCount) in
            self.documentId = totalCount
        }
    }
    func setUpData() {
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: AddRecipe.personName.seletedString(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: AddRecipe.documentName.seletedString(), strDescription: "", isPicker: false, isEditable: true))
    }
    
    func  validationForData(viewController:UIViewController) -> Bool {
        for i in 0...arrAllItems.count - 1 {
            let data:ItemList = numberOfItemAtIndex(index: i)
            if data.strDescription.count <= 0 {
                Alert().showAlert(message: "please select".localized() + " " + data.strTitle, viewController: viewController)
                return false
            }
        }
        if imgSelectedImage == nil {
            Alert().showAlert(message: "please select".localized() + "Document Image".localized() , viewController: viewController)
            return false
        }
        return true
    }
    
    func saveDataInDatabase(viewcontroller:UIViewController,success SuccessBlock: @escaping ((Bool) -> Void)) {
        DispatchQueue.main.async {
            MBProgressHub.showLoadingSpinner(sender:viewcontroller.view)
            self.objPersonProofDetail.saveinDataBase(documentId: self.documentId + 1, strDocumentName: self.arrAllItems[1].strDescription, strPersonName: self.arrAllItems[0].strDescription, proofImage: self.imgSelectedImage!) { (isSuccess) in
                SuccessBlock(isSuccess)
                MBProgressHub.dismissLoadingSpinner(viewcontroller.view)
            }
        }
    }
    
    func  setUpCell(cell:LoanTextFieldTableViewCell,index:Int)  {
        let data:ItemList = numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.tag = index
        cell.btnCall.isHidden = true
        cell.btnSelection.tag = index
        if data.isPicker {
            cell.showButtonSelection(index: index)
            if cell.txtDescription.text!.isEmpty {
                cell.txtDescription.text = kSelectOption.localized()
            }
        }else {
            cell.hideButtonSelection()
        }
        cell.callclicked = {[weak self] value in
            print("selected Value = \(value)")
        }
        cell.selectedText = {[weak self] (value,index) in
            self!.arrAllItems[index].strDescription = value
        }
        cell.textFieldResign = {[weak self] (index) in
            self?.tableView?.reloadData()
        }
        cell.alertMessage = {[weak self] message in
            Alert().showAlert(message: message, viewController: self!.viewController!)
        }
        cell.selectedIndex = {[weak self] index in
        }
    }
}
extension AddProofViewController {
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self?.objAddProofViewModel.imgSelectedImage  = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!)
                }
            }
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self?.objAddProofViewModel.imgSelectedImage  = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!)
                }
            }
        }
    }
    
    func moveToImage() {
        let alertController = UIAlertController(title: kAppName, message: kSelectOption.localized(), preferredStyle: .alert)
        // Create the actions
        let cameraAction = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.takeImageFromCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.takeImageFromGallery()
        }
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
}
extension AddProofViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrAllItems.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130.0
        } else {
            return 100.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrAllItems[index] as! T
    }
}

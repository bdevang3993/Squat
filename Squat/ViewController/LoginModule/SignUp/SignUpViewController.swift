//
//  SignUpViewController.swift
//  Squat
//
//  Created by devang bhavsar on 17/02/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var topConstaintTableView: NSLayoutConstraint!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnLogo: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tblDisplay: UITableView!
    @IBOutlet weak var viewBtn: UIView!
    @IBOutlet weak var btnSubmit: UIButton!
    var userDefault = UserDefaults.standard
    let objImagePickerViewModel = ImagePickerViewModel()
    var objSignUpViewModel = SignUpViewModel()
    var objDetailModel = DetailViewModel()
    var selectedType = SelectedViewModel.signUp.strSelectedTitle()
    var personInformation:TaSelectedPersonInformation?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtn.frame.size.height = 100.0
        }
        self.btnSubmit!.setTitle("SAVE".localized(), for: .normal)
        self.btnLogo.setTitle("ImagePicker".localized(), for: .normal)
        if selectedType == SelectedViewModel.signUp.strSelectedTitle() {
            objSignUpViewModel.tableView = self.tblDisplay
            objSignUpViewModel.viewController = self
            objSignUpViewModel.setUpDataForSignUp()
           // widthofImageLogo.multiplier  = 0.4
        } else {
            topConstaintTableView.constant  = -(imgLogo.frame.height + 20)
            imgLogo.isHidden = true
            btnLogo.isHidden = true
            objDetailModel.tableView = self.tblDisplay
            objDetailModel.viewController = self
            objDetailModel.setUpDataForDetail()
        }
        objSignUpViewModel.setHeaderView(headerView: viewHeader, strTitle: selectedType)
        btnSubmit.setUpButton()
        self.tblDisplay.delegate = self
        self.tblDisplay.dataSource = self
    }

    @IBAction func btnLogoClicked(_ sender: Any) {
        self.alertForImage()
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        if selectedType == SelectedViewModel.signUp.strSelectedTitle() {
            if imgLogo.image!.isEqualToImage(image: UIImage(named: "logo")!) {
                Alert().showAlert(message: "please select your profie image".localized(), viewController: self)
                return
            }
            let valiedData = objSignUpViewModel.setupValidation()
            if valiedData {
                objSignUpViewModel.saveInDatabase { (isSuccess) in
                    self.userDefault.set(self.objSignUpViewModel.arrAllItems[0].strDescription, forKey: kName)
                    self.userDefault.set(self.objSignUpViewModel.arrAllItems[self.objSignUpViewModel.arrAllItems.count - 3].strDescription, forKey: kEmailId)
                    self.userDefault.set(self.objSignUpViewModel.arrAllItems[self.objSignUpViewModel.arrAllItems.count - 2].strDescription, forKey: kPassword)
                    setAlertWithCustomAction(viewController: self, message: kDataSaveSuccess, ok: { (isSuccess) in
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isfailed) in
                    }
                }
            }
        } else {
            let valiedData = objDetailModel.setupValidation()
            if valiedData {
                personInformation!(objDetailModel.arrAllItems[0].strDescription, objDetailModel.arrAllItems[1].strDescription, objDetailModel.arrAllItems[2].strDescription)
                self.dismiss(animated: true, completion: nil)
            }
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
extension SignUpViewController {
    func alertForImage() {
        let alertController = UIAlertController(title: "Image Selection".localized(), message: "please select one option".localized(), preferredStyle: .alert)
        // Create the actions
        let cameraAction = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
          MBProgressHub.showLoadingSpinner(sender: self.view)
           self.takeImageFromCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
           MBProgressHub.showLoadingSpinner(sender: self.view)
            self.takeImageFromGallery()
        }
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            self?.imgLogo.image = value
            let success = saveImage(image: value)
            if success.0 == true {
                self!.objSignUpViewModel.imageData = success.1
            } else {
                Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!)
            }
        }
    }
    
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            self?.imgLogo.image = value
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self!.objSignUpViewModel.imageData = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!)
                }
            }
        }
    }
}
extension SignUpViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedType == SelectedViewModel.signUp.strSelectedTitle() {
            return objSignUpViewModel.numberOfRows()
        } else {
            return objDetailModel.numberOfRows()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if selectedType == SelectedViewModel.signUp.strSelectedTitle() {
            return objSignUpViewModel.heightForRow()
        } else {
            return objDetailModel.heightForRow()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplay.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        if selectedType == SelectedViewModel.signUp.strSelectedTitle() {
            objSignUpViewModel.setUpCellData(cell: cell, index: indexPath.row)
        } else {
            objDetailModel.setUpCellData(cell: cell, index: indexPath.row)
        }
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
}

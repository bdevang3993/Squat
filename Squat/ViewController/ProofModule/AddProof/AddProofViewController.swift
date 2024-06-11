//
//  AddProofViewController.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import UIKit

class AddProofViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplay: UITableView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnSave: UIButton!
    var objImagePickerViewModel = ImagePickerViewModel()
    var objAddProofViewModel = AddProofViewModel()
    var updatedAllData:updateDataWhenBackClosure?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        objAddProofViewModel.setHeaderView(headerView: viewHeader)
        objAddProofViewModel.setUpCustomDelegate()
        objAddProofViewModel.getDocumentId()
        objAddProofViewModel.setUpData()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewButton.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewButton.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        self.tblDisplay.dataSource = self
        self.tblDisplay.delegate = self
        btnSave.setUpButton()
        btnSave.setTitle("SAVE".localized(), for: .normal)
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
    @IBAction func btnSaveClicked(_ sender: Any) {
        let validate = objAddProofViewModel.validationForData(viewController: self)
        if validate {
            objAddProofViewModel.saveDataInDatabase(viewcontroller: self) { (isSuccess) in
                if isSuccess {
                    FileStoragePath.objShared.backupDatabase(databaseName: kDatabaseName)
                    self.updatedAllData!()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            }
        }
    }
    
}
extension AddProofViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddProofViewModel.numberOfRows() + 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objAddProofViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if  indexPath.row == objAddProofViewModel.numberOfRows() {
            let cell = tblDisplay.dequeueReusableCell(withIdentifier: "AddRecipesTableViewCell") as! AddRecipesTableViewCell
            return cell
        } else {
            let cell = tblDisplay.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
            objAddProofViewModel.setUpCell(cell: cell, index: indexPath.row)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row == objAddProofViewModel.numberOfRows()  {
            self.moveToImage()
        }
    }
    
}

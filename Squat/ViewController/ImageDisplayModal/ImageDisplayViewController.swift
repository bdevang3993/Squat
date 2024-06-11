//
//  ImageDisplayViewController.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 17/03/22.
//

import UIKit

class ImageDisplayViewController: UIViewController {
    var imageV = UIImageView()
    var selectedImage = UIImage()
    var isFromImageDisplay:Bool = true
    @IBOutlet weak var circularview: Circle!
    @IBOutlet weak var imgDisplay: UIImageView!
    @IBOutlet weak var tblDisplyData: UITableView!
    @IBOutlet weak var btnImageDisplay: UIButton!
    @IBOutlet weak var viewDataSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    var objImageDisplayViewModel = ImageDisplayVIewModel()
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var btnChooseImage: UIButton!
    var strTitle:String = "Biography Description".localized()
    var updateDatabase:taSelectedIndex?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        btnSave.setUpButton()
        btnChooseImage.setUpButton()
        if isFromImageDisplay {
            strTitle = "Image".localized()
            self.perform(#selector(setUpAnimation), with: nil, afterDelay: 0.5)
            self.setUpHidenImage()
        } else {
            self.tblDisplyData.delegate = self
            self.tblDisplyData.dataSource = self
            btnImageDisplay.setTitle("Select Profile".localized(), for: .normal)
            btnChooseImage.setTitle("Choose Images".localized(), for: .normal)
            btnSave.setTitle("SAVE".localized(), for: .normal)
            var height = 80
            if UIDevice.current.userInterfaceIdiom == .pad {
               height = 100
            }
            viewDataSave.frame = CGRect(x: viewDataSave.frame.origin.x, y: viewDataSave.frame.origin.y, width: viewDataSave.frame.width, height: CGFloat(height))
        }
        self.objImageDisplayViewModel.viewController = self
        self.objImageDisplayViewModel.setHeaderView(headerView: viewHeader, strTitle: strTitle)
    }
    
    @objc func setUpAnimation() {
            self.imageV.removeFromSuperview()
        var width = 150
        if UIDevice.current.userInterfaceIdiom == .pad {
            width = 230
        }
            imageV = UIImageView(frame: CGRect(x: 50, y: 100, width: width, height: width))
            imageV.center = view.center
            imageV.image = selectedImage//UIImage(named: "1", in: Bundle(for: type(of: self)), compatibleWith: nil)
                view.addSubview(imageV)
            UIView.animate(withDuration: 6.0) {
                self.imageV.transform = CGAffineTransform(scaleX: 2.7, y: 2.7)
            } completion: { (isSuccess) in
            }
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let valied = self.objImageDisplayViewModel.checkForValidation()
        if imgDisplay.image == nil {
            Alert().showAlert(message: "please select the profile image".localized(), viewController: self)
            return
        }
        if valied {
            MBProgressHub.showLoadingSpinner(sender: self.view)
            self.objImageDisplayViewModel.matchData(strPlaceName: objImageDisplayViewModel.arrDescription[1].description, strDescription: objImageDisplayViewModel.arrDescription[2].description, image: imgDisplay.image!)
            self.objImageDisplayViewModel.updateDatabase = {[weak self] in
                DispatchQueue.main.async {
                    MBProgressHub.dismissLoadingSpinner((self?.view)!)
                    setAlertWithCustomAction(viewController: self!, message:kDataSaveSuccess, ok: { (isSuccess) in
                        DispatchQueue.main.async {
                            FileStoragePath.objShared.backupDatabase(databaseName: kDatabaseName)
                            self!.updateDatabase!(self!.objImageDisplayViewModel.personId)
                            self!.dismiss(animated: true, completion: nil)
                        }
                    }, isCancel: false) { (isFailed) in
                        MBProgressHub.dismissLoadingSpinner((self?.view)!)
                    }
                }
                
            }
        }
    }
    
    @IBAction func btnImageDisplayClicked(_ sender: Any) {
        self.objImageDisplayViewModel.viewController = self
        self.objImageDisplayViewModel.objImagePickerViewModel.numberOFImages = 1
        self.objImageDisplayViewModel.setUpImagePicker(isFromProfile: true, imageView: imgDisplay)
    }
    
    @IBAction func btnChooseClicked(_ sender: Any) {
        self.objImageDisplayViewModel.viewController = self
        self.objImageDisplayViewModel.objImagePickerViewModel.numberOFImages = 0
        self.objImageDisplayViewModel.setUpImagePicker(isFromProfile: false, imageView: nil)
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

extension ImageDisplayViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objImageDisplayViewModel.arrTitle.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 120.0
        } else {
            return 80.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplyData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
       
        objImageDisplayViewModel.setUpCellData(cell: cell, index: indexPath.row, section: 0)
        return cell
    }
    
}

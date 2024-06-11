//
//  MainViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 18/02/22.
//

import UIKit

class MainViewModel: NSObject {
    var headerViewXib:CommanView?
    var selectedImageIndex:Int = 0
    var arrMP3FileList = ["Ram Dhoon","Vishnu Sahasranamam Part 1","Vishnu Sahasranamam Part 2"]
    var arrNack = [UIImage(named: "nackless"),UIImage(named: "nackless1"),UIImage(named: "nackless2"),UIImage(named: "nackless3"),UIImage(named: "nackless4"),UIImage(named: "nackless5"),UIImage(named: "nackless6"),UIImage(named: "nackless7"),UIImage(named: "nackless8")]
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = false
        headerViewXib!.btnHeader.setTitle("Detail".localized(), for: .normal)
        headerViewXib!.btnHeader.addTarget(MainViewController(), action:#selector(MainViewController.enterDetail), for: .touchUpInside)
        headerViewXib!.lblTitle.text = "Om Santi".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(MainViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)

    }
}
extension MainViewController {
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            self!.imgMain = value
         
            self?.userDefault.synchronize()
            self?.mergeImages(index: self!.objMainViewModel.selectedImageIndex)
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            self?.userDefault.set(success.1, forKey: kProfileImage)
//            if success.0 == true {
//                self!.imageData = success.1
//            } else {
//                Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
//            }
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            self!.imgMain = value
            self?.userDefault.synchronize()
            self?.mergeImages(index: self!.objMainViewModel.selectedImageIndex)
          
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            self?.userDefault.set(success.1, forKey: kProfileImage)
//            DispatchQueue.main.async {
//                if success.0 == true {
//                    self!.imageData = success.1
//                }else {
//                    Alert().showAlert(message: "your Image is not saved please try again", viewController: self!)
//                }
//            }
        }
    }
    
    func moveToImage() {
        let alertController = UIAlertController(title: kAppName, message: kSelectOption.localized() + " " + "to take User image".localized(), preferredStyle: .alert)
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
extension MainViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objMainViewModel.arrNack.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageSliderCollectionViewCell = imageSliderCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageSliderCollectionViewCell", for: indexPath) as! ImageSliderCollectionViewCell
        cell.imgSlider.image = objMainViewModel.arrNack[indexPath.row]
        cell.imgSlider.clipsToBounds = true
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        objMainViewModel.selectedImageIndex = indexPath.row
        self.mergeImages(index: objMainViewModel.selectedImageIndex)
      //  imageSliderCollectionView.isHidden = true
    }
}
extension MainViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 128, height: 128)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
}

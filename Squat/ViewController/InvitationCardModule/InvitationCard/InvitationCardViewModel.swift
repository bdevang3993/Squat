//
//  InvitationCardViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 19/02/22.
//

import UIKit
import Screenshots
import Floaty
import CoreLocation

class InvitationCardViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var viewController:UIViewController?
    var arrIteamList = [ItemList]()
    var arrMemberList = [FamilyList]()
    var arrMutatableString = [NSMutableAttributedString]()
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var strCutomerNumber:String = ""
    var isFromTervi:Bool = false
    var objPersonInfoDetailQuery = PersonInfoDetailQuery()
    var objPersonCardDetail = PersonCardDetail()
    var objPersonFamilyDetail = PersonFamilyDetail()
    var objTerviInfoDetail = TerviInfoDetail()
    var personId:Int = -1
    var memberId:Int = -1
    var strBesnuImageName:String = ""
    var imageBesnu:UIImage?
    var arrMemberRecord = [[String:Any]]()
    var dicPersonRecord = [String:Any]()
    var isFromEdit:Bool = false
    var strAddTitle:String = "Add".localized()
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
        if isFromEdit {
            strAddTitle = "Edit".localized()
        }
        headerViewXib!.btnHeader.setTitle(strAddTitle, for: .normal)
        headerViewXib!.btnHeader.addTarget(InvitationCardViewController(), action:#selector(InvitationCardViewController.setUpData), for: .touchUpInside)
        if isFromTervi {
            headerViewXib!.lblTitle.text = "Tervi Vidhi".localized()
        } else {
            headerViewXib!.lblTitle.text = "Rasam Kirya(BESNU)".localized()
        }
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(InvitationCardViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func fetchPersonId() {
        self.getDocumetDirectory()
        objPersonInfoDetailQuery.getRecordsCount { (lastRecord) in
            self.personId =  lastRecord + 1
        }
    }
    func getDocumetDirectory() {
        DocumentDirectoryAccess.objShared.createDirectory { (isSucces) in
        }
    }
    func  fetchMemberId() {
        objPersonFamilyDetail.getRecordsCount { (lastRecord) in
            self.memberId = lastRecord + 1
        }
        objPersonFamilyDetail.fetchByPersonId(personid: self.personId - 1) { (record) in
            self.arrMemberRecord = record
        } failure: { (isFaield) in
        }
    }
    func setUpDataOnCard() {
        
 //  set up family Name
        
  //      arrAllItems.append(ItemList(strTitle: InvitationDetail.faimaliyMember.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        let newPassed  = "Passed Away Peacefully On".localized()
        arrMutatableString.removeAll()
        let name = self.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        let newName = name[0].strDescription.capitalizingFirstLetter()
        let dod = self.arrIteamList.filter{$0.strTitle == InvitationDetail.dod.strSelectedTitle()}
        let string1 =   NSMutableAttributedString()
            .largebold(newName)
            .normal("\n \(newPassed) \(dod[0].strDescription)\n")
        arrMutatableString.append(string1)
        
        let besnuDate = self.arrIteamList.filter{$0.strTitle == InvitationDetail.besnuDate.strSelectedTitle()}
        let startTime = self.arrIteamList.filter{$0.strTitle == InvitationDetail.startTime.strSelectedTitle()}
        let endTime = self.arrIteamList.filter{$0.strTitle == InvitationDetail.endTime.strSelectedTitle()}
        let placeName = self.arrIteamList.filter{$0.strTitle == InvitationDetail.placeName.strSelectedTitle()}
        let address = self.arrIteamList.filter{$0.strTitle == InvitationDetail.address.strSelectedTitle()}
        let fullAddresForGetLatAndLong:String = "\(placeName[0].strDescription),\(address[0].strDescription)"
        self.getLatLongFromAddress(strCityName: fullAddresForGetLatAndLong)
        let newDate = "Date".localized()
        let newTime = "Time".localized()
        let newPlace = "place".localized()
        let string2 = NSMutableAttributedString()
            .bold("Rasam Kirya(BESNU)".localized() + " : ")
            .normal("\(newDate) : \(besnuDate[0].strDescription),\n\(newTime): \(startTime[0].strDescription) to \(endTime[0].strDescription) \n ")
            .bold("\(newPlace) : \(placeName[0].strDescription),")
            .normal(address[0].strDescription)
        arrMutatableString.append(string2)
        
        var arrMutableData = [NSMutableAttributedString]()
        for i in 0...self.arrMemberList.count - 1 {
            let data = self.arrMemberList[i]
            if  i != self.arrMemberList.count - 1 {
                let string3 = NSMutableAttributedString()
                    .bold(data.strName.capitalizingFirstLetter())
                    .normal("(\(data.strRelationShip)" + ") ,")
                arrMutableData.append(string3)
            } else {
                let string3 = NSMutableAttributedString()
                    .bold(data.strName.capitalizingFirstLetter())
                    .normal("(\(data.strRelationShip)" + ") ")
                arrMutableData.append(string3)
            }
        }
        let inSertedBy = "Inserted By".localized()
        let string3 = NSMutableAttributedString()
            .normal("\(inSertedBy): ")
        for i in 0...arrMutableData.count - 1 {
            string3.append(arrMutableData[i])
        }
        arrMutatableString.append(string3)
        
        let firmAddress = self.arrIteamList.filter{$0.strTitle == InvitationDetail.firmAddress.strSelectedTitle()}
        var strarrayData = [String]()
        strarrayData = firmAddress[0].strDescription.components(separatedBy: ",")
        if strarrayData.count < 2 {
            strarrayData = firmAddress[0].strDescription.components(separatedBy: " ")
        }
        var straddrssData:String = ""
        if strarrayData.count > 1 {
            for i in 1...strarrayData.count - 1 {
                if i == 1 {
                    straddrssData = strarrayData[i]
                } else {
                    straddrssData +=  "," + strarrayData[i]
                }
            }
        }

        let mobileNumber = self.arrIteamList.filter{$0.strTitle == InvitationDetail.mobileNumber.strSelectedTitle()}
        let referalNumber = self.arrIteamList.filter{$0.strTitle == InvitationDetail.referalNumber.strSelectedTitle()}
        let String4 = NSMutableAttributedString()
            .normal("\("Firm".localized()): ")
            .bold("\(strarrayData[0]),\n")
            .normal("\(straddrssData),\n\("MobileNumber".localized()): \(mobileNumber[0].strDescription), \(referalNumber[0].strDescription)")
       
        arrMutatableString.append(String4)
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func setUpDataForTervi() {
        arrMutatableString.removeAll()
        var strName:String = ""
        if let name = UserDefaults.standard.value(forKey: kName) {
            strName = name as! String
        }
        let fullName = self.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        strName = fullName[0].strDescription
        var strDod:String = ""
        if let dod = UserDefaults.standard.value(forKey: kDod) {
            strDod = dod as! String
        }
        let dod = self.arrIteamList.filter{$0.strTitle == InvitationDetail.dod.strSelectedTitle()}
        strDod = dod[0].strDescription
        let pap = "Passed Away Peacefully On".localized()
        let string1 =   NSMutableAttributedString()
            .largebold(strName)
            .normal("\n \(pap) \(strDod)\n")
        arrMutatableString.append(string1)
        
        let besnuDate = self.arrIteamList.filter{$0.strTitle == InvitationDetail.mundanDate.strSelectedTitle()}
        let startTime = self.arrIteamList.filter{$0.strTitle == InvitationDetail.startTime.strSelectedTitle()}
        let endTime = self.arrIteamList.filter{$0.strTitle == InvitationDetail.endTime.strSelectedTitle()}
       
        let newDate = "Date".localized()
        let newTime = "Time".localized()
        let newPlace = "place".localized()
        let mundan = "Mundan".localized()
        let string2 = NSMutableAttributedString()
            .bold("\t\(mundan) : \n")
            .bold("\(newDate): \(besnuDate[0].strDescription)\n\(newTime): \(startTime[0].strDescription) to \(endTime[0].strDescription) \n ")

        arrMutatableString.append(string2)
        
        
        
        let tervi = self.arrIteamList.filter{$0.strTitle == InvitationDetail.terviDate.strSelectedTitle()}
       // var arrAddress1 = [String]()

        let terviData = "Tervi".localized()
        let string3 = NSMutableAttributedString()
            .bold("\t\(terviData) :\n")
            .bold("\(newDate) : \(tervi[0].strDescription)\n\(newTime) : \(startTime[1].strDescription) to \(endTime[1].strDescription) \n ")
        arrMutatableString.append(string3)

        
        let placeName = self.arrIteamList.filter{$0.strTitle == InvitationDetail.placeName.strSelectedTitle()}
        let address = self.arrIteamList.filter{$0.strTitle == InvitationDetail.address.strSelectedTitle()}
        let fullAddressForLatAndLong = "\(placeName[0].strDescription),\(address[0].strDescription)"
        self.getLatLongFromAddress(strCityName: fullAddressForLatAndLong)
        let mobileNumber = self.arrIteamList.filter{$0.strTitle == InvitationDetail.mobileNumber.strSelectedTitle()}
        let referalNumber = self.arrIteamList.filter{$0.strTitle == InvitationDetail.referalNumber.strSelectedTitle()}
        var arrAddress = [String]()
        arrAddress = address[0].strDescription.components(separatedBy: ",")
        if arrAddress.count < 2 {
            arrAddress = address[0].strDescription.components(separatedBy: " ")
        }
        var strfullAddress:String = ""
        for i in 1...arrAddress.count - 1 {
            if i == 1 {
                strfullAddress = arrAddress[i]
            } else {
                strfullAddress +=  "," + arrAddress[i]
            }
        }
        let firm = "Firm".localized()
        let mobileStringNumber = "MobileNumber".localized()
        let String4 = NSMutableAttributedString()
            .bold("\(firm): ")
            .bold("\(placeName[0].strDescription),\n")
            .normal("\(strfullAddress),\n\(mobileStringNumber) : \(mobileNumber[0].strDescription), \(referalNumber[0].strDescription)")
       
        arrMutatableString.append(String4)
        self.tableView?.reloadData()
    }
    
    func getLatLongFromAddress(strCityName:String) {
        let address = strCityName
           let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { [self] (placemarks, error) in
               guard
                   let placemarks = placemarks,
                   let location = placemarks.first?.location
                           else {
                   // handle no location found
                MBProgressHub.dismissLoadingSpinner(self.viewController!.view)
                print("Error = \(error?.localizedDescription)")
                   return
               }
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude
            print("from function Latitude  = \(self.latitude) and longitude = \(self.longitude)")
            MBProgressHub.dismissLoadingSpinner(self.viewController!.view)
               // Use your location
           }
    }
}
//MARK:- TableView Data
extension InvitationCardViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "InvitationTableViewCell") as!InvitationTableViewCell
            if self.objInvitationCard.arrMutatableString.count > 0 {
                cell.lblInvitation.attributedText = self.objInvitationCard.arrMutatableString[indexPath.row]
            } else {
                cell.lblInvitation.attributedText = NSAttributedString(string: "")
            }
        cell.selectionStyle = .none
        return cell
    }
}
extension InvitationCardViewController {
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            self?.imgLogo.image = value
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
             self?.imgLogo.image = value
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
    
    func screenshot() -> UIImage{
        objInvitationCard.headerViewXib?.imgBack.isHidden = true
        objInvitationCard.headerViewXib?.btnHeader.isHidden = true
        self.btnImage.isHidden = true
        let tableViewScreenShot = self.tblDisplayData.screenshot
        let viewScreenShot:UIImage = self.viewHeader.screenshot!
        let newImage:UIImage = viewScreenShot.mergeImage(image2: tableViewScreenShot!)
        self.btnImage.isHidden = false
        objInvitationCard.headerViewXib?.imgBack.isHidden = false
        objInvitationCard.headerViewXib?.btnHeader.isHidden = false
        objInvitationCard.imageBesnu = newImage
        return newImage
    }
    
    func shareImage(image:UIImage) {
        var imageShare = [Any]()
        var urlData:URL?
        var urlData2:URL?
        var urlData3:URL?
        
        if strSelectedLocal == "en" {
            urlData = URL(string: "https://maps.apple.com/?daddr=\(objInvitationCard.latitude),\(objInvitationCard.longitude)")
            
            urlData2 = URL(string: "https://maps.google.com/maps?daddr=\(objInvitationCard.latitude),\(objInvitationCard.longitude)")
        }
   
        
        urlData3 = URL(string: playStoreURL)
        if urlData != nil && urlData2 != nil {
            imageShare = [image,urlData!,urlData2!,urlData3!]
        } else {
            imageShare = [image,urlData3!]
        }
        
        //let imageShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.isModalInPresentation = true
        activityViewController.popoverPresentationController?.sourceView = self.tblDisplayData
        activityViewController.completionWithItemsHandler = { [weak self] (value1,value2,value3,value4) in
            setAlertWithCustomAction(viewController: self!, message: "You have share Card successfully".localized(), ok: { (isSuccess) in
              //  self!.updateClosure!()
                self?.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isFailed) in
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
     }
    
    func setUpPopUpAlertMessage(strMessage:String) {
        let alertController = UIAlertController(title: kAppName, message:strMessage, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK".localized(), style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            firstTextField.keyboardType = .decimalPad
            if firstTextField.text!.count < 10 {
                Alert().showAlert(message: "please provide customer number more then 10 digit".localized(), viewController: self)
                return
            }
                self.objInvitationCard.strCutomerNumber = firstTextField.text!
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Number".localized()
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
//MARK:- Store Besnu in Database
extension InvitationCardViewController {
    func saveBesnuInDatabase() {

       if self.objInvitationCard.arrIteamList.count <= 0 {
        Alert().showAlert(message: "please filled the description from Add".localized(), viewController: self)
         return
        }
        
        let logo = UIImage(named:"logo")
        if imgLogo.image!.isEqualToImage(image: logo!) {
            Alert().showAlert(message: "please select the person image first".localized(), viewController: self)
            return
        }
        MBProgressHub.showLoadingSpinner(sender: self.view)
        
        let name = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        var isUpdate:Bool = false
         objInvitationCard.objPersonInfoDetailQuery.matchDataByName(strPersonName: name[0].strDescription, record: { (record) in
            let data = record
            if data.count > 0 {
                self.objInvitationCard.dicPersonRecord = data
                self.objInvitationCard.personId = data["personid"] as! Int
                isUpdate = true
                DispatchQueue.main.async {
                    self.setUpDataInDatabase(isUpdate:isUpdate)
                }
            }
        }, failure: { (isFailed) in
            DispatchQueue.main.async {
                self.setUpDataInDatabase(isUpdate:false)
            }
           
        })
    }

    func setUpDataInDatabase(isUpdate:Bool)  {
        let name = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        let newName = removeWhiteSpace(strData: name[0].strDescription.capitalizingFirstLetter()) 
        let dob = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.dod.strSelectedTitle()}
        let address = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.address.strSelectedTitle()}
        let firmAddress = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.firmAddress.strSelectedTitle()}
        let besnuDate = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.besnuDate.strSelectedTitle()}
        let besnuStartTime = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.startTime.strSelectedTitle()}
        let besnuEndTime = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.endTime.strSelectedTitle()}
        let mobileNumber = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.mobileNumber.strSelectedTitle()}
        let referalNumber = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.referalNumber.strSelectedTitle()}
        let placeName = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.placeName.strSelectedTitle()}
        
        var imageNewData = Data()
        if objInvitationCard.imageBesnu == nil {
            objInvitationCard.imageBesnu = self.screenshot()
        }
        if objInvitationCard.imageBesnu != nil {
            let newData = saveImage(image: objInvitationCard.imageBesnu!)
            imageNewData = newData.1
        }
        var imgNewLogo = Data()
        if imgLogo.image != nil {
            let newData = saveImage(image: imgLogo.image!)
            imgNewLogo = newData.1
        }
        
        let placeWithAddress:String = placeName[0].strDescription
        let addressNew:String = address[0].strDescription
        let newAddress:String = "\(placeWithAddress),\(addressNew)"
        
        if isUpdate {
            for value in objInvitationCard.arrMemberList {
                var isMatch:Bool = false
                if objInvitationCard.arrMemberRecord.count > 0 {
                    for i in 0...objInvitationCard.arrMemberRecord.count - 1 {
                        let filterData =  objInvitationCard.arrMemberRecord[i]
                        if value.strName == filterData["name"] as! String {
                            isMatch = true
                            break
                        }
                    }
                    if !isMatch {
                        objInvitationCard.objPersonFamilyDetail.saveinDataBase(familyid: self.objInvitationCard.memberId , personid: self.objInvitationCard.personId, strName: value.strName, strRelationShip: value.strRelationShip) { _ in
                        }
                    }
                }
            }
            

            var name:String = newName
            if name.count <= 0 {
                name = objInvitationCard.dicPersonRecord["personName"] as! String
            }
            objInvitationCard.objPersonInfoDetailQuery.updateDataBase(strPersonid: objInvitationCard.dicPersonRecord["personid"] as! Int, strName: newName, strDob: self.objInvitationCard.dicPersonRecord["dob"] as! String, strDod: dob[0].strDescription, personImage: imgNewLogo, strBesnuAddress:newAddress, strFirmAddress:  firmAddress[0].strDescription, strBesnuDate: besnuDate[0].strDescription, strBesnuStartTime: besnuStartTime[0].strDescription, strBesnuEndTime: besnuEndTime[0].strDescription, strMobileNumber: mobileNumber[0].strDescription, strReferalNumber: referalNumber[0].strDescription, strAddressLatitude: objInvitationCard.latitude, strAddressLongitude: objInvitationCard.longitude) { (isSuccess) in
                if isSuccess {
                    self.checkImageInDatabase(personId: self.objInvitationCard.personId, personName: newName, imageData: imageNewData)
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "please try again", viewController: self)
                }
            }
            
        } else {
            for value in objInvitationCard.arrMemberList {
                    objInvitationCard.objPersonFamilyDetail.saveinDataBase(familyid: self.objInvitationCard.memberId , personid: self.objInvitationCard.personId, strName: value.strName, strRelationShip: value.strRelationShip) { _ in
                    }
            }

            self.objInvitationCard.objPersonInfoDetailQuery.saveinDataBase(personid: objInvitationCard.personId, strName: newName, strDob: strBirthDate, strDod: dob[0].strDescription, personImage: imgNewLogo, strBesnuAddress: newAddress, strFirmAddress: firmAddress[0].strDescription, strBesnuDate: besnuDate[0].strDescription, strBesnuStartTime: besnuStartTime[0].strDescription, strBesnuEndTime: besnuEndTime[0].strDescription, strMobileNumber: mobileNumber[0].strDescription, strReferalNumber: referalNumber[0].strDescription,strAddressLatitude:objInvitationCard.latitude, strAddressLongitude:objInvitationCard.longitude) { (isSuccess) in
                if isSuccess {
                    self.checkImageInDatabase(personId: self.objInvitationCard.personId, personName: newName, imageData: imageNewData)
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            }
        }

    }
    
    func checkImageInDatabase(personId:Int,personName:String,imageData:Data)  {
        self.objInvitationCard.objPersonCardDetail.fetchDataPersonId(personid: personId) { (result) in
            if result.count > 0 {
                self.saveImageInDatabase(personId: personId, personName: personName, imageData: imageData, isUpdate: true)
            }
        } failure: { (isFailed) in
            self.saveImageInDatabase(personId: personId, personName: personName, imageData: imageData, isUpdate: false)
        }
    }
    
    func saveImageInDatabase(personId:Int,personName:String,imageData:Data,isUpdate:Bool) {
        DispatchQueue.main.async {
            if isUpdate {
                let imageName = "\(personName)\(personId)BN.png"
                DocumentDirectoryAccess.objShared.saveImageDocumentDirectory(name: imageName, imageData: imageData)
               let success =  self.objInvitationCard.objPersonCardDetail.updateBesnuCard(personid: personId, besnuCardImage: imageName)
                MBProgressHub.dismissLoadingSpinner(self.view)
                if success {
                    Alert().showAlert(message: "Your data saved successfully", viewController: self)
                } else {
                    Alert().showAlert(message: "please try again", viewController: self)
                }
            } else {
                let imageName = "\(personName)\(personId)BN.png"
                DocumentDirectoryAccess.objShared.saveImageDocumentDirectory(name: imageName, imageData: imageData)
                self.objInvitationCard.objPersonCardDetail.saveinDataBase(personId: personId, strPersonName: personName, besnuCard: imageName, terviCard: "") { (isSuccess) in
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    if isSuccess {
                        Alert().showAlert(message: "Your data saved successfully".localized(), viewController: self)
                    } else {
                        Alert().showAlert(message: "please try again".localized(), viewController: self)
                    }
                }
            }
        }
    }
}
//MARK:- Store Tervi in Database
extension InvitationCardViewController {
    func saveTerviInDatabase() {
        if self.objInvitationCard.arrIteamList.count <= 0 {
            Alert().showAlert(message: "please filled the description from Add".localized(), viewController: self)
            return
        }
        let logo = UIImage(named:"logo")
        if imgLogo.image!.isEqualToImage(image: logo!) {
            Alert().showAlert(message: "please select the person image first".localized(), viewController: self)
            return
        }
        let fullName = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        MBProgressHub.showLoadingSpinner(sender: self.view)
        var isUpdate:Bool = false
        objInvitationCard.objTerviInfoDetail.fetchDataByName(name: fullName[0].strDescription) { (result) in
            if result.count > 0 {
                self.objInvitationCard.personId = result["personId"] as! Int
                isUpdate = true
            }
            DispatchQueue.main.async {
                self.setUpDataInDatabaseForTervi(isUpdate: isUpdate)
            }
        } failure: { (isFailed) in
            DispatchQueue.main.async {
                self.checkInBesnuDataBase(name: fullName[0].strDescription)
//                self.setUpDataInDatabaseForTervi(isUpdate: false)
            }
        }
    }
    
    func checkInBesnuDataBase(name:String) {
        var isUpdate:Bool = false
        objInvitationCard.objPersonInfoDetailQuery.matchDataByName(strPersonName: name) { (result) in
            if result.count > 0 {
                if result.count > 0 {
                    self.objInvitationCard.personId = result["personid"] as! Int
                }
                DispatchQueue.main.async {
                    self.setUpDataInDatabaseForTervi(isUpdate: isUpdate)
                }
            }
        } failure: { (isFailed) in
            self.setUpDataInDatabaseForTervi(isUpdate: false)
        }

    }
    
    func setUpDataInDatabaseForTervi(isUpdate:Bool)  {
        
        let placeName = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.placeName.strSelectedTitle()}
        let address = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.address.strSelectedTitle()}
        let fullName = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.fullName.strSelectedTitle()}
        let dod = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.dod.strSelectedTitle()}
        let mobileNumber = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.mobileNumber.strSelectedTitle()}
        let referalNumber = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.referalNumber.strSelectedTitle()}
        let mundanDate = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.mundanDate.strSelectedTitle()}
        let terviDate = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.terviDate.strSelectedTitle()}
        let startTime = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.startTime.strSelectedTitle()}
        let endTime = self.objInvitationCard.arrIteamList.filter{$0.strTitle == InvitationDetail.endTime.strSelectedTitle()}
        
        var imageNewData = Data()
        if objInvitationCard.imageBesnu == nil {
            objInvitationCard.imageBesnu = self.screenshot()
        }
        if objInvitationCard.imageBesnu != nil {
            let newData = saveImage(image: objInvitationCard.imageBesnu!)
            imageNewData = newData.1
        }
        
        if isUpdate {
            self.objInvitationCard.objTerviInfoDetail.updateDataBase(personId: objInvitationCard.personId, strDod: dod[0].strDescription, strMundanDate: mundanDate[0].strDescription, strTerviDate: terviDate[0].strDescription, strMundanStartTime: startTime[0].strDescription, strMundanEndTime: endTime[0].strDescription, strTerviStartTime: startTime[1].strDescription, strTerviEndTime: endTime[1].strDescription, strPlaceName: placeName[0].strDescription, strAddress: address[0].strDescription,strMobileNumber: mobileNumber[0].strDescription, strReferalNumber: referalNumber[0].strDescription) { (isSuccess) in
                if isSuccess {
                    self.checkImageInDatabaseForTervi(personId: self.objInvitationCard.personId, imageData: imageNewData, name: fullName[0].strDescription)
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            }
            
        } else {
            
            self.objInvitationCard.objTerviInfoDetail.saveinDataBase(personId: objInvitationCard.personId, strPersonName: fullName[0].strDescription, strDod: dod[0].strDescription, strMundanDate: mundanDate[0].strDescription, strTerviDate: terviDate[0].strDescription, strMundanStartTime: startTime[0].strDescription, strMundanEndTime: endTime[0].strDescription, strTerviStartTime: startTime[1].strDescription, strTerviEndTime: endTime[1].strDescription, strPlaceName: placeName[0].strDescription, strAddress: address[0].strDescription, strMobileNumber: mobileNumber[0].strDescription, strReferealNumber: referalNumber[0].strDescription) { (isSuccess) in
                if isSuccess {
                    self.checkImageInDatabaseForTervi(personId: self.objInvitationCard.personId, imageData: imageNewData, name: fullName[0].strDescription)
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            }
        }
    }
    
    func checkImageInDatabaseForTervi(personId:Int,imageData:Data,name:String)  {
        self.objInvitationCard.objPersonCardDetail.fetchDataPersonId(personid: personId) { (result) in
            if result.count > 0 {
                self.objInvitationCard.strBesnuImageName = result["besnuCard"] as! String
                self.saveImageInDatabaseForTervi(personId: personId, imageData: imageData, isUpdate: true, name: name)
            }
        } failure: { (isFailed) in
            self.saveImageInDatabaseForTervi(personId: personId, imageData: imageData, isUpdate: false, name: name)
        }
    }
    
    func saveImageInDatabaseForTervi(personId:Int,imageData:Data,isUpdate:Bool,name:String) {
        DispatchQueue.main.async {
            if isUpdate {
                let imageName = "\(name)\(personId)TV.png"
                DocumentDirectoryAccess.objShared.saveImageDocumentDirectory(name: imageName, imageData: imageData)
                let success =  self.objInvitationCard.objPersonCardDetail.updateTerviCard(personid: personId, terviCard: imageName)
                MBProgressHub.dismissLoadingSpinner(self.view)
                if success {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "Your data saved successfully".localized(), viewController: self)
                } else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            } else {
                let imageName = "\(name)\(personId)TV.png"
                DocumentDirectoryAccess.objShared.saveImageDocumentDirectory(name: imageName, imageData: imageData)
                self.objInvitationCard.objPersonCardDetail.saveinDataBase(personId: personId, strPersonName: name, besnuCard: self.objInvitationCard.strBesnuImageName, terviCard: imageName) { (isSuccess) in
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    if isSuccess {
                        MBProgressHub.dismissLoadingSpinner(self.view)
                        Alert().showAlert(message: "Your data saved successfully".localized(), viewController: self)
                    } else {
                        MBProgressHub.dismissLoadingSpinner(self.view)
                        Alert().showAlert(message: "please try again".localized(), viewController: self)
                    }
                }
              
            }
        }
    }
    
    func openLangaugeSelectrion() {
        let objForgotPasswordViewController:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        objForgotPasswordViewController.isFromLanguage = true
        objForgotPasswordViewController.modalPresentationStyle = .overFullScreen
        self.present(objForgotPasswordViewController, animated: true, completion: nil)
    }
}
extension InvitationCardViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Prefer Language".localized(), icon: UIImage(named: "language")) {item in
            DispatchQueue.main.async {
                self.openLangaugeSelectrion()
            }
        }
        floaty.addItem("SAVE".localized() + " " + "Card".localized(), icon: UIImage(named: "save")) {item in
            DispatchQueue.main.async {
                if self.isFromTervi  {
                    self.saveTerviInDatabase()
                }else {
                    self.saveBesnuInDatabase()
                }
            }
        }
        floaty.addItem("Share".localized() + " " + "Card".localized(), icon: UIImage(named: "share")) {item in
            DispatchQueue.main.async {
                let image = self.screenshot()
                DispatchQueue.main.async {
                    if self.isFromTervi  {
                        self.saveTerviInDatabase()
                    }else {
                        self.saveBesnuInDatabase()
                    }
                    self.shareImage(image: image)
                }
            }
        }
        floaty.addItem("Share Card Via WhatsApp".localized(), icon: UIImage(named: "whatsApp")) {item in
            if self.objInvitationCard.strCutomerNumber.count < 2  {
                self.setUpPopUpAlertMessage(strMessage: "please enter customer number".localized())
                return
            }
            DispatchQueue.main.async {
                ShareOnWhatsApp.objShared.viewController = self
                ShareOnWhatsApp.objShared.shareSuccess = { [weak self] in
                    DispatchQueue.main.async {
                        setAlertWithCustomAction(viewController: self!, message: "You have shared the card successfully".localized(), ok: { (isSuccess) in
                            //self!.updateClosure!()
                            self?.dismiss(animated: true, completion: nil)
                        }, isCancel: false) { (isFailed) in
                        }
                    }
                }
                ShareOnWhatsApp.objShared.shareImageOnWhatsApp(numbeString: self.objInvitationCard.strCutomerNumber, selectdImage: self.screenshot(), view: self.view) { (isSuccess) in
                    Alert().showAlert(message: "You have shared the card successfully".localized(), viewController: self)
                } failed: { (strError) in
                    Alert().showAlert(message: strError, viewController: self)
                }
            }
        }
        self.view.addSubview(floaty)
    }

}

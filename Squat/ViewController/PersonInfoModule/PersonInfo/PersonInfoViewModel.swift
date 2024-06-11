//
//  PersonInfoViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 24/02/22.
//

import UIKit

class PersonInfoViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var arrPersonInfoDataList = [PersonInfoDataList]()
    var arrOldPersonInfoList = [PersonInfoDataList]()
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var arrAllItems = [ItemList]()
    var arrMemberList = [FamilyList]()
    var objPersonInfoDetailQuery = PersonInfoDetailQuery()
    var objPersonFamilyDetail = PersonFamilyDetail()
    var objPersonCardDetail = PersonCardDetail()
    var isTerviList:Bool = false
    var isCardList:Bool = false
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
        if isCardList {
            headerViewXib!.lblTitle.text = "Card".localized() + " " + "List".localized()
        }else if isTerviList {
            headerViewXib!.lblTitle.text = "Tervi".localized() + " " + "List".localized()
        } else {
            headerViewXib!.lblTitle.text = "BESNU".localized() + " " + "List".localized()
        }
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(PersonInfoListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)

    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }

    func fetchAllData(lblData:UILabel) {
        MBProgressHub.showLoadingSpinner(sender: (viewController?.view)!)
        objPersonInfoDetailQuery.fetchData { (personData) in
            self.arrPersonInfoDataList.removeAll()
            for value in personData {
                let objData = PersonInfoDataList(personid: value["personid"] as! Int, strpersonName: value["personName"] as! String, strDob: value["dob"] as! String, strDod: value["dod"] as! String, strPersonImage: value["personImage"] as! Data, strBesnuAddress: value["besnuAddress"] as! String, strFirmAddress: value["firmAddress"] as! String, strBesnuDate: value["besnuDate"] as! String, strBesnuStartTime: value["besnuStartTime"] as! String, strBesnuEndTime: value["besnuEndTime"] as! String, strMobileNumber: value["mobileNumber"] as! String, strReferalNumber: value["referalNumber"] as! String, latitude: value["addressLatitude"] as! Double, longitude: value["addressLongitude"] as! Double)
                self.arrPersonInfoDataList.append(objData)
            }
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.arrOldPersonInfoList = self.arrPersonInfoDataList
            self.tableView?.reloadData()
        } failure: { (isFaield) in
            lblData.isHidden = false
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.arrPersonInfoDataList.removeAll()
            self.tableView?.reloadData()
        }
    }
    func setUpCustomCell(cell:PersonInfoTableViewCell,index:Int) {
        let data:PersonInfoDataList = numberOfItemAtIndex(index: index)
        cell.lblName.text = data.strpersonName
        cell.lblDate.text = data.strBesnuDate
    }
    func filterData(txtSearchData:String) {
        if txtSearchData.count < 1 {
            self.arrPersonInfoDataList = self.arrOldPersonInfoList
        }else {
            self.arrPersonInfoDataList = self.arrOldPersonInfoList.filter{$0.strpersonName.lowercased().contains(txtSearchData.lowercased())}
        }
        self.tableView?.reloadData()
    }
    
    func setupdateForMove(index:Int) {
        let data:PersonInfoDataList = self.arrPersonInfoDataList[index]
        UserDefaults.standard.set(data.strPersonImage, forKey: kProfileImage)
        UserDefaults.standard.synchronize()
        let date = self.checkForDateCompare(saveDate: data.strBesnuDate)
        if date < 0 {
            Alert().showAlert(message: "You can't be edit this data".localized(), viewController: self.viewController!)
            return
        }
        
        var arrSaveMemberList = [[String:Any]]()
        objPersonFamilyDetail.fetchByPersonId(personid: data.personid) { (record) in
            arrSaveMemberList = record
        } failure: { (isFalied) in
            Alert().showAlert(message: "issue for get data please try again".localized(), viewController: self.viewController!)
        }
        
  //      var imageData = Data()
//        objPersonCardDetail.fetchDataPersonId(personid: data.personid) { (result) in
//            if let besnuCard = result["besnuCard"] {
//                imageData = besnuCard as! Data
//            }
//        } failure: { (isFailed) in
//            Alert().showAlert(message: "Can't find image", viewController: self.viewController!)
//        }


        arrAllItems.removeAll()
       
        arrAllItems.append(ItemList(strTitle: InvitationDetail.fullName.strSelectedTitle(), strDescription: data.strpersonName, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.dod.strSelectedTitle(), strDescription: data.strDod, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.besnuDate.strSelectedTitle(), strDescription: data.strBesnuDate, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: data.strBesnuStartTime, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: data.strBesnuEndTime, isPicker: true, isEditable: true))
        let arrAddress = data.strBesnuAddress.components(separatedBy: ",")
        arrAllItems.append(ItemList(strTitle: InvitationDetail.placeName.strSelectedTitle(), strDescription: arrAddress[0], isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.address.strSelectedTitle(), strDescription: arrAddress[1], isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.faimaliyMember.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.firmAddress.strSelectedTitle(), strDescription: data.strFirmAddress, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mobileNumber.strSelectedTitle(), strDescription: data.strMobileNumber, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.referalNumber.strSelectedTitle(), strDescription: data.strReferalNumber, isPicker: false, isEditable: true))
        
        arrMemberList.removeAll()
        for value in arrSaveMemberList {
            arrMemberList.append(FamilyList(strName: value["name"] as! String, strRelationShip: value["relationShip"] as! String))
        }

        self.moveToViewController(arrAllItems: arrAllItems, arrMemberList: arrMemberList, imgData: data.strPersonImage)
    }
    
    func moveToViewController(arrAllItems:[ItemList],arrMemberList:[FamilyList],imgData:Data) {
        let objInvitationCardViewController:InvitationCardViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationCardViewController") as! InvitationCardViewController
        objInvitationCardViewController.objInvitationCard.imageBesnu = UIImage(data: imgData)
        objInvitationCardViewController.objInvitationCard.isFromEdit = true
        objInvitationCardViewController.objInvitationCard.arrIteamList = arrAllItems
        objInvitationCardViewController.objInvitationCard.arrMemberList = arrMemberList
        viewController!.revealViewController()?.pushFrontViewController(objInvitationCardViewController, animated: true)
        objInvitationCardViewController.imgLogo.image = UIImage(data: imgData)
        objInvitationCardViewController.objInvitationCard.setUpDataOnCard()
    }
    func checkForDateCompare(saveDate:String) -> Int {
        let convertSavedDate:Date = dateFormatter.date(from: saveDate)!
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to:convertSavedDate).day!
        return diffInDays
    }
    func removeDataFromDatabase(index:Int) {
        let personId = self.arrPersonInfoDataList[index].personid
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        objPersonInfoDetailQuery.delete(id: personId) { (isSuccess) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            if isSuccess {
                self.arrPersonInfoDataList.remove(at: index)
                self.tableView?.reloadData()
                Alert().showAlert(message: kDeleteData, viewController: self.viewController!)
            } else {
                Alert().showAlert(message: "please try again".localized(), viewController: self.viewController!)
            }
        }
    }
}
extension PersonInfoViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrPersonInfoDataList.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 40.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrPersonInfoDataList[index] as! T
    }
}
extension PersonInfoListViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    if isCardList {
                        self.objPersonCardListViewModel.filterData(strSearchData: txtPersonName.text!)
                    }else if isTerviList {
                        self.objTerviInfoViewModel.filterData(txtSearchData: txtPersonName.text!)
                    } else {
                        self.objPersonInfo.filterData(txtSearchData: txtPersonName.text!)
                    }
                    return true
                }
            }
        if txtPersonName.text!.count > 1 {
            if isCardList {
                self.objPersonCardListViewModel.filterData(strSearchData: txtPersonName.text!  + string)
            }else if isTerviList {
                self.objTerviInfoViewModel.filterData(txtSearchData: txtPersonName.text!  + string)
            } else {
                self.objPersonInfo.filterData(txtSearchData: txtPersonName.text!  + string)
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblPersonData!.reloadData()
        return true
    }
}

//
//  InvitationViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 19/02/22.
//

import UIKit

class InvitationDescriptionViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var objPersonInfoDetailQuery = PersonInfoDetailQuery()
    var viewController:UIViewController?
    var arrAllItems = [ItemList]()
    var arrFamilyList = [FamilyList]()
    var isFromTervi:Bool = false
    var isFromEdit:Bool = false
    var isCheckForBesnuCard:Bool = false
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    func setHeaderView(headerView:UIView,isFromAddData:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromTervi {
            headerViewXib!.lblTitle.text = "Tervi Description".localized()
        }else {
            headerViewXib!.lblTitle.text = "BESNU Description".localized()
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(InvitationDescriptionViewController(), action: #selector(InvitationDescriptionViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func setUpDataForDetail() {
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: InvitationDetail.fullName.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.dod.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.besnuDate.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.placeName.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.address.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.faimaliyMember.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.firmAddress.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mobileNumber.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.referalNumber.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        self.tableView?.reloadData()
    }
    func setUpDataForTervi() {
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: InvitationDetail.fullName.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.dod.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mundanDate.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.terviDate.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.placeName.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.address.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mobileNumber.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.referalNumber.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        self.tableView?.reloadData()
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int) {
        let data:ItemList = arrAllItems[index]
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
        if cell.lblTitle.text == InvitationDetail.mobileNumber.strSelectedTitle() || cell.lblTitle.text == InvitationDetail.referalNumber.strSelectedTitle() {
            cell.txtDescription.keyboardType = .decimalPad
        } else {
            cell.txtDescription.keyboardType = .default
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
            let data:ItemList = self!.numberOfItemAtIndex(index: index)
            let strTitle = data.strTitle
            if strTitle == InvitationDetail.faimaliyMember.strSelectedTitle() {
                self?.setUpMemberName()
            }
            if strTitle == InvitationDetail.startTime.strSelectedTitle() || strTitle == InvitationDetail.endTime.strSelectedTitle() {
                self?.setUpTimePicker(index: index)
            }else {
                self?.setUpPicker(index: index)
            }
        }
    }
    func matchForData(name:String, success successBlock:@escaping((Bool) -> Void))  {
        let newLater = name.capitalizingFirstLetter()
        objPersonInfoDetailQuery.matchDataByName(strPersonName: newLater) { (result) in
                if result.count > 0 {
                    successBlock(true)
                } else {
                    successBlock(false)
                }
        } failure: { (isFailed) in
                successBlock(false)
        }
    }
    
    func setUpMemberName() {
        let objInviationView:InvitationDescriptionViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationDescriptionViewController") as! InvitationDescriptionViewController
        objInviationView.modalPresentationStyle = .overFullScreen
        objInviationView.isFromAddFamily = true
        objInviationView.objFamilyMemberViewModel.arrFamilyList = self.arrFamilyList
        objInviationView.selectedFamilyMember = {[weak self] value in
            self?.arrFamilyList = value
            if value.count > 0 {
                var strFamilyName:String = ""
                for i in 0...self!.arrFamilyList.count - 1 {
                    let data = self?.arrFamilyList[i]
                    if i == 0 {
                        strFamilyName = data!.strName + " " + "( " + data!.strRelationShip + " )"
                    } else {
                        strFamilyName +=  ", " + data!.strName + " " + "( " + data!.strRelationShip + " )"
                    }
                }
                for i in 0...self!.arrAllItems.count - 1 {
                    if self!.arrAllItems[i].strTitle == InvitationDetail.faimaliyMember.strSelectedTitle() {
                        self!.arrAllItems[i].strDescription = strFamilyName
                    }
                }
            }
            self?.tableView?.reloadData()
        }
        
        viewController?.present(objInviationView, animated: true, completion: nil)
    }
    
    func setUpTimePicker(index:Int) {
        PickerView.objShared.setUpTimePicker(viewController: viewController!) { (time) in
            self.arrAllItems[index].strDescription = time
            self.tableView?.reloadData()
        }
    }
    func setUpPicker(index:Int)  {
        if index == 1 {
            PickerView.objShared.setUpDatePickerWithDate(viewController: viewController!) { (date) in
                self.arrAllItems[index].strDescription = self.dateFormatter.string(from: date)
                self.tableView?.reloadData()
                self.checkforName()
            }
        } else {
            PickerView.objShared.setUpDatePickerWithoutStartDateToday(viewController: viewController!) { (date) in
                let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                self.arrAllItems[index].strDescription = self.dateFormatter.string(from: date)
                if InvitationDetail.mundanDate.strSelectedTitle() ==  self.arrAllItems[index].strTitle {
                    self.arrAllItems[index + 3].strDescription = self.dateFormatter.string(from: modifiedDate)
                }
                self.tableView?.reloadData()
            }
        }
    }
    
    func checkforName()  {
      
        if isFromTervi {
            let value = removeWhiteSpace(strData: arrAllItems[0].strDescription)
            self.matchForData(name: value) { (isSucess) in
                if !isSucess {
                    DispatchQueue.main.async {
                        Alert().showAlert(message: "given name is not exist please add Besnu card first".localized(), viewController: self.viewController!)
                    }
                } else {
                    self.isCheckForBesnuCard = true
                }
            }
        }
    }
    func setUpValidation() -> Bool {
        for i in 0...arrAllItems.count - 1 {
            var data:ItemList = numberOfItemAtIndex(index: i)
            if data.strTitle == InvitationDetail.faimaliyMember.strSelectedTitle() {
                if arrFamilyList.count > 0 {
                    let title = arrFamilyList[0].strName
                    if title.count > 0 {
                        data.strDescription  = arrFamilyList[0].strName
                    }
                }
            }
            if data.strDescription.isEmpty {
                Alert().showAlert(message: "please provide".localized() + " " + data.strTitle, viewController: self.viewController!)
                return false
            }
        }
        return true
    }
    
    func setUpValidationForTervi() -> Bool {
        if !isCheckForBesnuCard && !isFromEdit {
            Alert().showAlert(message: "given name is not exist please add Besnu card first".localized(), viewController: self.viewController!)
            return false
        }
        for i in 0...arrAllItems.count - 1 {
            let data:ItemList = numberOfItemAtIndex(index: i)
            if data.strDescription.isEmpty {
                Alert().showAlert(message: "please provide".localized() + " " + data.strTitle, viewController: viewController!)
                return false
            }
        }
        return true
    }
}
extension InvitationDescriptionViewModel:CustomTableDelegate,CustomTableDataSource {
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

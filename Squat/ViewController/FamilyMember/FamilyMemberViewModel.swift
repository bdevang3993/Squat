//
//  FamilyMemberViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 21/02/22.
//

import UIKit

class FamilyMemberViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var numberOfSection:Int = 1
    var arrAllItems = [ItemList]()
    var arrFamilyList = [FamilyList]()
    var arrListOfRelationShip = [String]()
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
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Family Detail".localized()
        headerViewXib!.btnHeader.isHidden = false
        headerViewXib!.btnHeader.setTitle("Add".localized(), for: .normal)
        headerViewXib!.btnHeader.addTarget(InvitationDescriptionViewController(), action:#selector(InvitationDescriptionViewController.addMember), for: .touchUpInside)
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
        arrAllItems.append(ItemList(strTitle: InvitationDetail.relationShip.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        if arrFamilyList.count <= 0 {
            arrFamilyList.append(FamilyList(strName: "", strRelationShip: ""))
        }
        if arrFamilyList.count > 0 {
            numberOfSection = arrFamilyList.count
        }
        arrListOfRelationShip.removeAll()
        arrListOfRelationShip.append(FamilyMemberCategory.father.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.mother.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.husband.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.wife.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.brother.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.sisterinLaw.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.brotherinLaw.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.sister.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.son.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.daughterinLaw.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.daughter.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.uncle.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.aunty.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.grandSoninLaw.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.grandDaughteinLaw.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.greatGrandSon.selectedString())
        arrListOfRelationShip.append(FamilyMemberCategory.greatGrandDaughterinLaw.selectedString())
       
        self.tableView?.reloadData()
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int,section:Int) {
        let data:ItemList = arrAllItems[index]
        cell.lblTitle.text = data.strTitle
        let familyName = arrFamilyList[section]
        if index == 0 {
            cell.txtDescription.text = familyName.strName
        } else {
            cell.txtDescription.text = familyName.strRelationShip
        }
        cell.txtDescription.tag = section
        cell.btnCall.isHidden = true
        cell.btnSelection.tag = section
        if data.isPicker {
            cell.showButtonSelection(index: section)
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
            //self!.arrAllItems[index].strDescription = value
            self!.arrFamilyList[index].strName = value
        }
        cell.textFieldResign = {[weak self] (index) in
            self?.tableView?.reloadData()
        }
        cell.alertMessage = {[weak self] message in
            Alert().showAlert(message: message, viewController: self!.viewController!)
        }
        cell.selectedIndex = {[weak self] index in
            self?.setUpRelationPicker(index: index)
        }
    }
    
    func setUpRelationPicker(index:Int) {
        PickerView.objShared.setUPickerWithValue(arrData: arrListOfRelationShip, viewController: viewController!) { (value) in
            self.arrFamilyList[index].strRelationShip = value//""
            self.tableView?.reloadData()
        }
    }
    
    func setUpValidation() -> Bool {
        for i in 0...self.arrFamilyList.count - 1 {
            let data = self.arrFamilyList[i]
            if data.strName.isEmpty {
                Alert().showAlert(message: "please enter Name at".localized() + " \(i + 1) " + "index".localized(), viewController: viewController!)
                return false
            }
            if data.strRelationShip.isEmpty {
                Alert().showAlert(message: "please choose relationship of the member at".localized() + " \(i + 1) " + "index".localized(), viewController: viewController!)
                return false
            }
        }
        return true
    }
}
extension FamilyMemberViewModel:CustomTableDelegate,CustomTableDataSource {
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

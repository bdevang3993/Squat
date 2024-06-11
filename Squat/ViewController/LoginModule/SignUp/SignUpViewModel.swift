//
//  SignUpViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 17/02/22.
//

import UIKit

class SignUpViewModel: NSObject {
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var strTitle:String = ""
    var imageData = Data()
    var arrAllItems = [ItemList]()
    var objUserInfoDetailQuery = UserInfoDetailQuery()
    func setHeaderView(headerView:UIView,strTitle:String) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        self.strTitle = strTitle
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = strTitle
        headerViewXib!.btnBack.isHidden = false
        if   self.strTitle == "Change Password" {
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib?.btnBack.addTarget(SignUpViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        } else {
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib?.btnBack.addTarget(SignUpViewController(), action: #selector(SignUpViewController.backClicked), for: .touchUpInside)
        }
        
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.setUpCustomDelegate()
        self.setUpDataForSignUp()
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func setUpDataForSignUp() {
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.name.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.address.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.mobileNumber.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.email.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.password.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: SignUpDisplayTitle.confirmPassword.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        self.tableView?.reloadData()
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int) {
        let data:ItemList = arrAllItems[index]
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.tag = index
        cell.btnCall.isHidden = true
        if data.isPicker {
            cell.showButtonSelection(index: index)
        }else {
            cell.hideButtonSelection()
        }
        if data.strTitle == SignUpDisplayTitle.mobileNumber.strSelectedTitle() {
            cell.txtDescription.keyboardType = .numberPad
        }else if data.strTitle == SignUpDisplayTitle.email.strSelectedTitle() {
            cell.txtDescription.keyboardType = .emailAddress
        }else {
            cell.txtDescription.keyboardType = .default
        }
        if data.strTitle == SignUpDisplayTitle.password.strSelectedTitle() || data.strTitle == SignUpDisplayTitle.confirmPassword.strSelectedTitle() {
            cell.txtDescription.isSecureTextEntry = true
        } else {
            cell.txtDescription.isSecureTextEntry = false
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
    }
    
    func setupValidation() -> Bool {
        if arrAllItems[0].strDescription.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + arrAllItems[0].strTitle, viewController: viewController!)
            return false
        }
        for i in 3...arrAllItems.count - 1 {
            let item = arrAllItems[i]
            if item.strDescription.isEmpty {
                Alert().showAlert(message: "please provide".localized() + " " + item.strTitle, viewController: viewController!)
                return false
            }
            if item.strTitle == SignUpDisplayTitle.email.strSelectedTitle() {
                if !isValidEmail(emailStr: arrAllItems[i].strDescription) {
                    Alert().showAlert(message: "please provide valied email id".localized(), viewController: viewController!)
                    return false
                }
            }
            if item.strTitle == SignUpDisplayTitle.password.strSelectedTitle() {
                if item.strDescription.count < 6 {
                    Alert().showAlert(message: "password should be more then 5 character".localized(), viewController: viewController!)
                    return false
                }
                if item.strDescription != arrAllItems[i+1].strDescription {
                    Alert().showAlert(message: "password does not match please provide new password and re-enter password both are same".localized(), viewController: viewController!)
                    return false
                }
            }
        }
        return true
    }
    func saveInDatabase(success SuccessBlock: @escaping (Bool) -> Void) {
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        objUserInfoDetailQuery.saveinDataBase(strName: self.arrAllItems[0].strDescription, strAddress: self.arrAllItems[1].strDescription, strMobileNumber: self.arrAllItems[2].strDescription, strEmailId: self.arrAllItems[3].strDescription, strPassword: self.arrAllItems[4].strDescription, strPhoto: imageData) { (isSucccess) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            if isSucccess {
                SuccessBlock(true)
            }else {
                Alert().showAlert(message: "please try again".localized(), viewController: self.viewController!)
            }
        }
    }
}
extension SignUpViewModel:CustomTableDelegate,CustomTableDataSource {
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

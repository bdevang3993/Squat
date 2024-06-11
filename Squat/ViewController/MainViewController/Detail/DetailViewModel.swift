//
//  DetailViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 18/02/22.
//

import UIKit

class DetailViewModel: NSObject {
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var strTitle:String = ""
    var arrAllItems = [ItemList]()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func setUpDataForDetail() {
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: PersonDetail.name.strSelectedTitle(), strDescription: "", isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: PersonDetail.dob.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: PersonDetail.dod.strSelectedTitle(), strDescription: "", isPicker: true, isEditable: true))
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
            self?.setUpPicker(index: index)
        }
    }
    
    func setupValidation() -> Bool {
        strBirthDate = arrAllItems[1].strDescription
        for i in 0...arrAllItems.count - 1 {
            let item = arrAllItems[i]
            if item.strDescription.isEmpty {
                Alert().showAlert(message: "please provide".localized() + " " + item.strTitle, viewController: viewController!)
                return false
            }
        }
        return true
    }
    
    func setUpPicker(index:Int)  {
        PickerView.objShared.setUpDatePickerWithDate(viewController: viewController!) { (date) in
            self.arrAllItems[index].strDescription = self.dateFormatter.string(from: date)
            self.tableView?.reloadData()
        }
    }
}
extension DetailViewModel:CustomTableDelegate,CustomTableDataSource {
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

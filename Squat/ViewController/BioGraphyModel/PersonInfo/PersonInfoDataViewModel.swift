//
//  PersonInfoViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 22/03/22.
//

import UIKit

class PersonInfoDataViewModel: NSObject {
    var objCustomTableView = CustomTableView()
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var arrOldData = [BiographyData]()
    var arrFilterData = [BiographyData]()
    var objBioGraphyDetail = BioGraphyDetail()
    func setHeaderView(headerView:UIView,strTitle:String) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = strTitle
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(PersonInfoViewController(), action: #selector(PersonInfoViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func fetchAllData() {
        objBioGraphyDetail.fetchData { (result) in
            self.arrOldData.removeAll()
            for value in result {
                let data = BiographyData(personId: value["personId"] as! Int, personPlaceName: value["personPlaceName"] as! String, personDescription: value["personDescription"] as! String, personImage: value["personImage"] as! String, personName: value["personName"] as! String)
                let totalCount = self.arrOldData.filter{$0.personId == data.personId}
                if totalCount.count <= 0 {
                    self.arrOldData.append(data)
                }
            }
            self.arrFilterData = self.arrOldData
            self.tableView?.reloadData()
        } failure: { (isFailed) in
            self.arrFilterData.removeAll()
            self.tableView?.reloadData()
        }
    }
    
    func filterData(strName:String) {
        if strName.count > 2 {
            self.arrFilterData = self.arrOldData.filter{$0.personName.contains(strName)}
            self.tableView?.reloadData()
        } else {
            self.arrFilterData = self.arrOldData
            self.tableView?.reloadData()
        }
    }
}
extension PersonInfoViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    self.objPersonInfoViewModel.filterData(strName: txtPersonName.text!)
                    return true
                }
            }
        if txtPersonName.text!.count > 1 {
            self.objPersonInfoViewModel.filterData(strName: txtPersonName.text! + string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblDispalyData.reloadData()
        return true
    }
}
extension PersonInfoDataViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrFilterData.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 120.0
        } else {
            return 80.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrFilterData[index] as! T
    }
}

//
//  ProofDisplayViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import UIKit

class ProofDisplayViewModel: NSObject {
    var headerViewXib:CommanView?
    var objCustomTableView = CustomTableView()
    var arrAllItems = [ProofDisplayData]()
    var arrOldAllItems = [ProofDisplayData]()
    var objPersonProofDetail = PersonProofDetail()
    var tableView:UITableView?
    var viewController:UIViewController?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = false
        headerViewXib!.btnHeader.setTitle("Add".localized(), for: .normal)
        headerViewXib?.btnHeader.addTarget(ProofDisplayViewController(), action: #selector(ProofDisplayViewController.addData), for: .touchUpInside)
        
        headerViewXib!.lblTitle.text = SideMenuTitle.personDocument.selectedString()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ProofDisplayViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func fetchData(lblNoData:UILabel) {
        arrAllItems.removeAll()
        objPersonProofDetail.fetchData { (record) in
            if record.count > 0 {
                for value in record {
                    let objData = ProofDisplayData(proofImage: value["proofImage"] as! Data,  documentName: value["documentName"] as! String, documentid: value["documentid"] as! Int, personName: value["personName"] as! String)
                    self.arrAllItems.append(objData)
                }
                self.arrOldAllItems = self.arrAllItems
                lblNoData.isHidden = true
                self.tableView?.reloadData()
            } else {
                self.arrAllItems.removeAll()
                lblNoData.isHidden = false
            }
            
        } failure: { (isfailed) in
            lblNoData.isHidden = false
            self.arrAllItems.removeAll()
        }
    }
    
    func setupCell(cell:ProofTableViewCell,index:Int){
        let data:ProofDisplayData = numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.documentName
        cell.imgProof.image = UIImage(data: data.proofImage)
    }
    
    func selectedCell(index:Int) {
        let data:ProofDisplayData = numberOfItemAtIndex(index: index)
        let objCardShowImageViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "CardShowImageViewController") as! CardShowImageViewController
        objCardShowImageViewController.modalPresentationStyle = .overFullScreen
        objCardShowImageViewController.imgDisplay.image = UIImage(data: data.proofImage)
        self.viewController?.present(objCardShowImageViewController, animated: true, completion: nil)
    }
    
    func removeDataAtIndex(index:Int, success successBlock:@escaping (Bool) -> Void) {
        MBProgressHub.showLoadingSpinner(sender: (viewController?.view)!)
        objPersonProofDetail.delete(id: index) { (isSucess) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            successBlock(isSucess)
        }
    }
    func filterData(strDocumentName:String) {
        if strDocumentName.count < 2 {
            arrAllItems = arrOldAllItems
        } else {
            arrAllItems = arrOldAllItems.filter{$0.documentName.lowercased().contains(strDocumentName)}
        }
        self.tableView?.reloadData()
    }
}
extension ProofDisplayViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrAllItems.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 300.0
        } else {
            return 250.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrAllItems[index] as! T
    }
}
extension ProofDisplayViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                self.objProofDisplayViewModel.filterData(strDocumentName: textField.text!)
                return true
            }
        }
        if txtSearch.text!.count > 1 {
            self.objProofDisplayViewModel.filterData(strDocumentName: textField.text!  + string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblDisplayData!.reloadData()
        return true
    }
}

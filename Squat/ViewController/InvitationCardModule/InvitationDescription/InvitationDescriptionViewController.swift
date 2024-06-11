//
//  InvitationDescriptionViewController.swift
//  Squat
//
//  Created by devang bhavsar on 19/02/22.
//

import UIKit

class InvitationDescriptionViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewButton: UIView!
    @IBOutlet weak var btnSave: UIButton!
    var isFromAddFamily:Bool = false
    var isFromTervi:Bool = false
    var isFromEdit:Bool = false
    var objInvitationDescriptionModel = InvitationDescriptionViewModel()
    var objFamilyMemberViewModel = FamilyMemberViewModel()
    var selectedFamilyMember:taSelectedFamilyMember?
    var selectedDetail:taSelectedDetailBesnu?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
        objInvitationDescriptionModel.isFromEdit = isFromEdit
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewButton.frame.size.height = (90.0 * (screenWidth/768.0))
        } else {
            viewButton.frame.size.height = (60.0 * (screenWidth/320.0))
        }
        if isFromAddFamily {
            objFamilyMemberViewModel.setHeaderView(headerView: viewHeader)
            if !isFromEdit {
                objFamilyMemberViewModel.setUpDataForDetail()
            }
            objFamilyMemberViewModel.tableView = self.tblDisplayData
            objFamilyMemberViewModel.viewController = self
            self.tblDisplayData.allowsSelectionDuringEditing = true
            self.tblDisplayData.reloadData()
        } else {
            objInvitationDescriptionModel.isFromTervi = isFromTervi
            objInvitationDescriptionModel.setHeaderView(headerView: viewHeader, isFromAddData: isFromAddFamily)
            if isFromTervi {
                if !isFromEdit {
                objInvitationDescriptionModel.setUpDataForTervi()
                }
            } else {
                if !isFromEdit {
                    objInvitationDescriptionModel.setUpDataForDetail()
                }
            }
            objInvitationDescriptionModel.tableView = self.tblDisplayData
            objInvitationDescriptionModel.viewController = self
            self.tblDisplayData.reloadData()
        }
        
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        btnSave.setUpButton()
        btnSave.setTitle("SAVE".localized(), for: .normal)
    }
    
    @objc func addMember() {
        objFamilyMemberViewModel.numberOfSection += 1
        objFamilyMemberViewModel.arrFamilyList.append(FamilyList(strName: "", strRelationShip: ""))
        tblDisplayData.reloadData()
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if isFromAddFamily {
           let valied = objFamilyMemberViewModel.setUpValidation()
            if valied {
                self.selectedFamilyMember!(objFamilyMemberViewModel.arrFamilyList)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            if isFromTervi {
                let valid = objInvitationDescriptionModel.setUpValidationForTervi()
                if valid {
                    self.dismissWithData()
                }
            } else {
                let valied = objInvitationDescriptionModel.setUpValidation()
                if valied {
                    self.dismissWithData()
                }
            }
        }
    }
    
    func dismissWithData() {
        self.selectedDetail!(objInvitationDescriptionModel.arrAllItems, objInvitationDescriptionModel.arrFamilyList)
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
extension InvitationDescriptionViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFromAddFamily {
            return objFamilyMemberViewModel.numberOfSection
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromAddFamily {
            return 2
        } else {
            return objInvitationDescriptionModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromAddFamily {
            return objFamilyMemberViewModel.heightForRow()
        } else {
            return objInvitationDescriptionModel.heightForRow()
        }
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        if isFromAddFamily {
            objFamilyMemberViewModel.setUpCellData(cell: cell, index: indexPath.row, section: indexPath.section)
        } else {
            objInvitationDescriptionModel.setUpCellData(cell: cell, index: indexPath.row)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if isFromAddFamily {
            if editingStyle == .delete {
                if indexPath.section >= 0 {
                    objFamilyMemberViewModel.numberOfSection -= 1
                    objFamilyMemberViewModel.arrFamilyList.remove(at: indexPath.section)
                    self.tblDisplayData.reloadData()
                }
            }
        }
    }
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isFromAddFamily {
            return 2
        } else {
          return 0
        }
    }
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
}

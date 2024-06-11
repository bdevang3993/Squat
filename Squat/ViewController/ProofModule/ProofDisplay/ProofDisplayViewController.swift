//
//  ProofDisplayViewController.swift
//  Squat
//
//  Created by devang bhavsar on 28/02/22.
//

import UIKit

class ProofDisplayViewController: UIViewController {

    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var lblNoDataFound: UILabel!
    var objProofDisplayViewModel = ProofDisplayViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        txtSearch.delegate  = self
        txtSearch.placeholder = "Document Name".localized()
        lblNoDataFound.text = "No data found".localized()
        lblNoDataFound.isHidden = true
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
        objProofDisplayViewModel.setHeaderView(headerView: viewHeader)
        objProofDisplayViewModel.tableView = self.tblDisplayData
        objProofDisplayViewModel.viewController = self
        objProofDisplayViewModel.setUpCustomDelegate()
        objProofDisplayViewModel.fetchData(lblNoData: lblNoDataFound)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
    }
    
    @objc func addData() {
        let objAddProofViewController:AddProofViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProofViewController") as! AddProofViewController
        objAddProofViewController.modalPresentationStyle = .overFullScreen
        objAddProofViewController.updatedAllData = {[weak self] in
            self!.objProofDisplayViewModel.fetchData(lblNoData: self!.lblNoDataFound)
        }
        self.present(objAddProofViewController, animated: true, completion: nil)
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
extension ProofDisplayViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objProofDisplayViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objProofDisplayViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "ProofTableViewCell") as! ProofTableViewCell
        objProofDisplayViewModel.setupCell(cell: cell, index: indexPath.row)
        return cell
     }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objProofDisplayViewModel.selectedCell(index: indexPath.row)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                self.objProofDisplayViewModel.removeDataAtIndex(index: indexPath.row) { (isSucess) in
                    if isSucess {
                        self.objProofDisplayViewModel.arrAllItems.remove(at: indexPath.row)
                        self.tblDisplayData.reloadData()
                        Alert().showAlert(message: kDataDeleted, viewController: self)
                    }
                }
            }
        }
    }
}

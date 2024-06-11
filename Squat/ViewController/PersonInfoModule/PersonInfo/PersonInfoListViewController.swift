//
//  PersonInfoListViewController.swift
//  Squat
//
//  Created by devang bhavsar on 24/02/22.
//

import UIKit

class PersonInfoListViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtPersonName: UITextField!
    @IBOutlet weak var tblPersonData: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    var objPersonInfo = PersonInfoViewModel()
    var objTerviInfoViewModel = TerviInfoViewModel()
    var objPersonCardListViewModel = PersonCardListViewModel()
    
    var isCardList:Bool = false
    var isTerviList:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
        objPersonInfo.isTerviList = isTerviList
        objPersonInfo.isCardList = isCardList
        objPersonInfo.setHeaderView(headerView: viewHeader)
        self.txtPersonName.placeholder = "Person Name".localized()
        self.txtPersonName.layer.borderColor = UIColor.black.cgColor
        self.txtPersonName.layer.borderWidth = 1.0
        self.txtPersonName.layer.masksToBounds = true
        self.txtPersonName.delegate = self
        self.lblNoData.text = "No data found".localized()
        self.lblNoData.isHidden = true
        if isCardList {
            objPersonCardListViewModel.setUpCustomDelegate()
            objPersonCardListViewModel.tableView = tblPersonData
            objPersonCardListViewModel.viewController = self
            objPersonCardListViewModel.fetchAllData(lblNoData: lblNoData)
        }
        else if isTerviList {
            objTerviInfoViewModel.setUpCustomDelegate()
            objTerviInfoViewModel.tableView = tblPersonData
            objTerviInfoViewModel.viewController = self
            objTerviInfoViewModel.fetchAllData(lblNoData: lblNoData)
        } else {
            objPersonInfo.setUpCustomDelegate()
            objPersonInfo.tableView = tblPersonData
            objPersonInfo.viewController = self
            objPersonInfo.fetchAllData(lblData: lblNoData)
        }
        self.tblPersonData.delegate = self
        self.tblPersonData.dataSource = self
        self.tblPersonData.tableFooterView = UIView()
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
extension PersonInfoListViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCardList {
            return objPersonCardListViewModel.numberOfRows()
        }else if isTerviList {
            return objTerviInfoViewModel.numberOfRows()
        } else {
            return objPersonInfo.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCardList {
            return objPersonCardListViewModel.heightForRow()
        }else if isTerviList {
            return objTerviInfoViewModel.heightForRow()
        } else {
            return objPersonInfo.heightForRow()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblPersonData.dequeueReusableCell(withIdentifier: "PersonInfoTableViewCell") as! PersonInfoTableViewCell
        if isCardList {
            objPersonCardListViewModel.setUpCustomCell(cell: cell, index: indexPath.row)
        }else if isTerviList {
            objTerviInfoViewModel.setUpCustomCell(cell: cell, index: indexPath.row)
        } else {
            objPersonInfo.setUpCustomCell(cell: cell, index: indexPath.row)
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isCardList {
            objPersonCardListViewModel.selectDataAtIndex(index: indexPath.row)
        }else if isTerviList {
            objTerviInfoViewModel.setupdateForMove(index: indexPath.row)
        } else {
            objPersonInfo.setupdateForMove(index: indexPath.row)
        }
      
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DispatchQueue.main.async {
                if self.isCardList {
                    self.objPersonCardListViewModel.removeDataFromDatabase(index: indexPath.row, lblData: self.lblNoData)
                } else if self.isTerviList {
                    self.objTerviInfoViewModel.removeDataFromDatabase(index: indexPath.row)
                } else {
                    self.objPersonInfo.removeDataFromDatabase(index: indexPath.row)
                }
            }
        }
    }
}

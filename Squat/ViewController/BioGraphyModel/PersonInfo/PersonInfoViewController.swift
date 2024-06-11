//
//  PersonInfoViewController.swift
//  Squat
//
//  Created by devang bhavsar on 22/03/22.
//

import UIKit

class PersonInfoViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDispalyData: UITableView!
    @IBOutlet weak var txtPersonName: UITextField!
    var objPersonInfoViewModel = PersonInfoDataViewModel()
    var updateBioGraphyValue:TaBiographyValueSuccess?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    func configureData() {
        self.objPersonInfoViewModel.tableView = self.tblDispalyData
        self.objPersonInfoViewModel.fetchAllData()
        self.objPersonInfoViewModel.setUpCustomDelegate()
        self.view.insertSubview(setUpBackgroundImage(imageName: kBackgroundImage), at: 0)
        self.txtPersonName.delegate = self
        objPersonInfoViewModel.setHeaderView(headerView: viewHeader, strTitle: "Person List".localized())
        txtPersonName.placeholder = "Person Name".localized()
        self.tblDispalyData.delegate = self
        self.tblDispalyData.dataSource = self
        self.tblDispalyData.tableFooterView = UIView()
    }
    
    
    @objc func backClicked() {
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
extension PersonInfoViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objPersonInfoViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objPersonInfoViewModel.heightForRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDispalyData.dequeueReusableCell(withIdentifier: "tableViewcell")!
        let data:BiographyData = objPersonInfoViewModel.numberOfItemAtIndex(index: indexPath.row)
        cell.textLabel?.text = data.personName
        cell.textLabel?.textAlignment = .center
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data:BiographyData = objPersonInfoViewModel.numberOfItemAtIndex(index: indexPath.row)
        updateBioGraphyValue!(data)
        self.dismiss(animated: true, completion: nil)
    }
}

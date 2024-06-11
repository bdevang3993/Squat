//
//  TerviInfoViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 26/02/22.
//

import UIKit

class TerviInfoViewModel: NSObject {
    var arrTerviInfoDataList = [TerviInfoDataList]()
    var arrOldTerviInfoDataList = [TerviInfoDataList]()
    var objCustomTableView = CustomTableView()
    var objTerviInfoDetail = TerviInfoDetail()
    var objPersonInfoDetailQuery = PersonInfoDetailQuery()
    var viewController:UIViewController?
    var tableView:UITableView?
    var arrAllItems = [ItemList]()
    var imageTerviData = Data()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func fetchAllData(lblNoData:UILabel)  {
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        objTerviInfoDetail.fetchData { (result) in
            self.arrTerviInfoDataList.removeAll()
            for value in result {
                let objTerviData = TerviInfoDataList(personId: value["personId"] as! Int, personName: value["personName"] as! String, dod: value["dod"] as! String, mundanDate: value["mundanDate"] as! String, terviDate: value["terviDate"] as! String, mundanStartTime: value["mundanStartTime"] as! String, mundanEndTime: value["mundanEndTime"] as! String, terviEndTime: value["terviEndTime"] as! String, terviStartTime: value["terviStartTime"] as! String, placeName: value["placeName"] as! String, address: value["address"] as! String, mobileNumber: value["mobileNumber"] as! String, referalNumber: value["referalNumber"] as! String)
                self.arrTerviInfoDataList.append(objTerviData)
            }
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.arrOldTerviInfoDataList = self.arrTerviInfoDataList
            self.tableView?.reloadData()
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.arrTerviInfoDataList.removeAll()
            lblNoData.isHidden = true
            
        }
    }

    func setUpCustomCell(cell:PersonInfoTableViewCell,index:Int) {
        let data:TerviInfoDataList = numberOfItemAtIndex(index: index)
        cell.lblName.text = data.personName
        cell.lblDate.text = data.terviDate
    }
    func filterData(txtSearchData:String) {
        if txtSearchData.count < 1 {
            self.arrTerviInfoDataList = self.arrOldTerviInfoDataList
        } else {
            self.arrTerviInfoDataList = self.arrOldTerviInfoDataList.filter{$0.personName.lowercased().contains(txtSearchData.lowercased())}
        }
        self.tableView?.reloadData()
    }
    func fetchImageData(personId:Int) {
        objPersonInfoDetailQuery.fetchDataByPersonId(personid: personId) { (result) in
            if result.count > 0 {
                self.imageTerviData = result["personImage"] as! Data
            }
        } failure: { (isFailed) in
        }
    }
    func setupdateForMove(index:Int) {
        
        let data:TerviInfoDataList = self.arrTerviInfoDataList[index]
        let date = self.checkForDateCompare(saveDate: data.terviDate)
        if date < 0 {
            Alert().showAlert(message: "You can't be edit this data", viewController: self.viewController!)
            return
        }
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        self.fetchImageData(personId: data.personId)
        arrAllItems.removeAll()
        arrAllItems.append(ItemList(strTitle: InvitationDetail.fullName.strSelectedTitle(), strDescription: data.personName, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.dod.strSelectedTitle(), strDescription: data.dod, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mundanDate.strSelectedTitle(), strDescription: data.mundanDate, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: data.mundanStartTime, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: data.mundanEndTime, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.terviDate.strSelectedTitle(), strDescription: data.terviDate, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.startTime.strSelectedTitle(), strDescription: data.terviStartTime, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.endTime.strSelectedTitle(), strDescription: data.terviEndTime, isPicker: true, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.placeName.strSelectedTitle(), strDescription: data.placeName, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.address.strSelectedTitle(), strDescription: data.address, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.mobileNumber.strSelectedTitle(), strDescription: data.mobileNumber, isPicker: false, isEditable: true))
        arrAllItems.append(ItemList(strTitle: InvitationDetail.referalNumber.strSelectedTitle(), strDescription: data.referalNumber, isPicker: false, isEditable: true))
        
        self.moveToViewController(arrAllItems: arrAllItems, imgData: imageTerviData)
    }
    
    func moveToViewController(arrAllItems:[ItemList],imgData:Data) {
        MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
        let objInvitationCardViewController:InvitationCardViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationCardViewController") as! InvitationCardViewController
        objInvitationCardViewController.objInvitationCard.imageBesnu = UIImage(data: imgData)
        objInvitationCardViewController.objInvitationCard.isFromEdit = true
        objInvitationCardViewController.isFromTervi = true
        objInvitationCardViewController.objInvitationCard.isFromTervi = true
        objInvitationCardViewController.objInvitationCard.arrIteamList = arrAllItems
        viewController!.revealViewController()?.pushFrontViewController(objInvitationCardViewController, animated: true)
        objInvitationCardViewController.imgLogo.image = UIImage(data: imgData)
        objInvitationCardViewController.objInvitationCard.setUpDataForTervi()
    }
    func checkForDateCompare(saveDate:String) -> Int {
        let convertSavedDate:Date = dateFormatter.date(from: saveDate)!
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to:convertSavedDate).day!
        return diffInDays
    }
    func removeDataFromDatabase(index:Int) {
        let personId = self.arrTerviInfoDataList[index].personId
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        objTerviInfoDetail.delete(id: personId) { (isSuccess) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            if isSuccess {
                self.arrTerviInfoDataList.remove(at: index)
                self.tableView?.reloadData()
                Alert().showAlert(message: kDeleteData, viewController: self.viewController!)
            } else {
                Alert().showAlert(message: "please try again", viewController: self.viewController!)
            }
        }
    }
}
extension TerviInfoViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrTerviInfoDataList.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 40.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrTerviInfoDataList[index] as! T
    }
}

//
//  PersonCardListViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 26/02/22.
//

import UIKit

class PersonCardListViewModel: NSObject {
    var arrPersonCardList = [PersonCardDetailData]()
    var arrOldPersonCardList = [PersonCardDetailData]()
    var objPersonCardDetail = PersonCardDetail()
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var tableView:UITableView?
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func fetchAllData(lblNoData:UILabel)  {
        MBProgressHub.showLoadingSpinner(sender: (self.viewController?.view)!)
        objPersonCardDetail.fetchData { (result) in
            self.arrPersonCardList.removeAll()
            for value in result {
                let objData = PersonCardDetailData(personId: value["personId"] as! Int, personName: value["personName"] as! String, besnuCard: value["besnuCard"] as! String, terviCard: value["terviCard"] as! String)
                self.arrPersonCardList.append(objData)
            }
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            self.arrOldPersonCardList = self.arrPersonCardList
        } failure: { (isFailed) in
            MBProgressHub.dismissLoadingSpinner((self.viewController?.view)!)
            lblNoData.isHidden = false
            self.arrPersonCardList.removeAll()
            self.tableView?.reloadData()
        }
    }
    
    func setUpCustomCell(cell:PersonInfoTableViewCell,index:Int) {
        let data:PersonCardDetailData = numberOfItemAtIndex(index: index)
        cell.lblName.text = data.personName
        cell.lblDate.text = ""
    }
    func filterData(strSearchData:String) {
        if strSearchData.count <= 1 {
            self.arrPersonCardList = self.arrOldPersonCardList
        } else {
            self.arrPersonCardList = self.arrOldPersonCardList.filter{$0.personName.lowercased().contains(strSearchData.lowercased())}
        }
        self.tableView?.reloadData()
    }
    
    func selectDataAtIndex(index:Int)  {
        let data:PersonCardDetailData = numberOfItemAtIndex(index: index)
        let alert = UIAlertController(title: kAppName , message: "Please select one option".localized(), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "BESNU Image".localized(), style: .destructive, handler: { action in
            let imageName = data.besnuCard
            DocumentDirectoryAccess.objShared.getImage(name: imageName) { (image) in
                self.dispalyImage(image: image)
            } failed: { (isFailed) in
                Alert().showAlert(message: "can't find image plase save the image from clicked on BESNU list when display data then from + button choose the  save option".localized(), viewController: self.viewController!)
            }

        }))
        alert.addAction(UIAlertAction(title: "Tervi Image".localized(), style: .destructive, handler: { action in
            let imageTervi = data.terviCard
            if imageTervi.count <= 0 {
                Alert().showAlert(message: "tervi information not found".localized(), viewController: self.viewController!)
                return
            }
            DocumentDirectoryAccess.objShared.getImage(name: imageTervi) { (image) in
                self.dispalyImage(image: image)
            } failed: { (isFailed) in
                Alert().showAlert(message: "can't find image plase save the image from clicked on BESNU list when display data then from + button choose the  save option".localized(), viewController: self.viewController!)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil))
        self.viewController?.present(alert, animated: true, completion: nil)
    }
    func  dispalyImage(image:UIImage)  {
        let objCardShowImageViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "CardShowImageViewController") as! CardShowImageViewController
        objCardShowImageViewController.modalPresentationStyle = .overFullScreen
        objCardShowImageViewController.selectedImage = image
        viewController?.present(objCardShowImageViewController, animated: true, completion: nil)
    }
    func removeDataFromDatabase(index:Int,lblData:UILabel) {
        let data:PersonCardDetailData = numberOfItemAtIndex(index: index)
        objPersonCardDetail.delete(id: data.personId) { (isSuccess) in
            if isSuccess{
                self.arrPersonCardList.remove(at: index)
                self.fetchAllData(lblNoData: lblData)
                Alert().showAlert(message: kDataDeleted, viewController: self.viewController!)
            }else {
                Alert().showAlert(message: "please try again".localized(), viewController: self.viewController!)
            }
        }
    }
}
extension PersonCardListViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrPersonCardList.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 40.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrPersonCardList[index] as! T
    }
}

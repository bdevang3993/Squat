//
//  BioGraphyViewModel.swift
//  Squat
//
//  Created by devang bhavsar on 19/03/22.
//

import UIKit

class BioGraphyViewModel: NSObject {
    var headerViewXib:CommanView?
    var objBioGraphyDetail = BioGraphyDetail()
    var arrBiographyData = [BiographyData]()
    var personId:Int = -1
    var updateAllData:TaSelectedValueSuccess?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = SideMenuTitle.biographic.selectedString()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(BioGraphyDisplayViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
       // self.setUpAllData()
    }
    
    func setUpAllData() {
        if  self.personId >= 0 {
            self.fetchAllData()
        } else {
            objBioGraphyDetail.getRecordsCount { (lastId) in
                self.personId = lastId
                DispatchQueue.main.async {
                    self.fetchAllData()
                }
            }
        }
    }
    
    func fetchAllData() {
        objBioGraphyDetail.fetchLastPerson(personId: self.personId) { (result) in
            self.arrBiographyData.removeAll()
            items.removeAll()
            for value in result {
                let data = BiographyData(personId: value["personId"] as! Int, personPlaceName: value["personPlaceName"] as! String, personDescription: value["personDescription"] as! String, personImage: value["personImage"] as! String, personName: value["personName"] as! String)
                self.arrBiographyData.append(data)
                DocumentDirectoryAccess.objShared.getImage(name:  value["personImage"] as! String) { (image) in
                    let glovoView = GlovoItem.init(image: image, text: value["personPlaceName"] as! String)
                    items.append(glovoView)
                   
                } failed: { (isFailed) in
                }
            }
            let personName = result[0]
            self.updateAllData!(personName["personName"] as! String)
        } failure: { (isFalied) in
        }
    }
}

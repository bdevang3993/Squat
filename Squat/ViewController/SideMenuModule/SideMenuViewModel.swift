//
//  SideMenuViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit

class SideMenuViewModel: NSObject {
    var arrDescription = [String]()
    func setUpDescription() {
        arrDescription.removeAll()
        arrDescription.append(SideMenuTitle.home.selectedString())
        arrDescription.append(SideMenuTitle.besnu.selectedString())
        arrDescription.append(SideMenuTitle.terviVidhi.selectedString())
        arrDescription.append(SideMenuTitle.personDocument.selectedString())
        arrDescription.append(SideMenuTitle.besnuList.selectedString())
        arrDescription.append(SideMenuTitle.terviList.selectedString())
        arrDescription.append(SideMenuTitle.personCardList.selectedString())
        arrDescription.append(SideMenuTitle.biographic.selectedString())
        arrDescription.append(SideMenuTitle.restoreData.selectedString())
        arrDescription.append(SideMenuTitle.deleteAccount.selectedString())
        arrDescription.append(SideMenuTitle.logOut.selectedString())
    }
}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSideMenuViewModel.arrDescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "RearTableViewCell") as! RearTableViewCell
        cell.lblDescrption.text = objSideMenuViewModel.arrDescription[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let strTitle = objSideMenuViewModel.arrDescription[indexPath.row]
        if strTitle == SideMenuTitle.home.selectedString() {
            let objHomeView:MainViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "MainViewController") as! MainViewController
            self.revealViewController()?.pushFrontViewController(objHomeView, animated: true)
        }else if  strTitle == SideMenuTitle.besnu.selectedString() {
            let objInvitationCard:InvitationCardViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationCardViewController") as! InvitationCardViewController
            self.revealViewController()?.pushFrontViewController(objInvitationCard, animated: true)
        }
        else if strTitle == SideMenuTitle.terviVidhi.selectedString() {
            let objInvitationCard:InvitationCardViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationCardViewController") as! InvitationCardViewController
            objInvitationCard.isFromTervi = true
            self.revealViewController()?.pushFrontViewController(objInvitationCard, animated: true)
        }
        else if strTitle == SideMenuTitle.besnuList.selectedString() {
            let objPersonInfoListViewController:PersonInfoListViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "PersonInfoListViewController") as! PersonInfoListViewController
            self.revealViewController()?.pushFrontViewController(objPersonInfoListViewController, animated: true)
        }
        else if strTitle == SideMenuTitle.terviList.selectedString() {
            let objPersonInfoListViewController:PersonInfoListViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "PersonInfoListViewController") as! PersonInfoListViewController
            objPersonInfoListViewController.isTerviList = true
            self.revealViewController()?.pushFrontViewController(objPersonInfoListViewController, animated: true)
        }
        else if strTitle == SideMenuTitle.personCardList.selectedString() {
            let objPersonInfoListViewController:PersonInfoListViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "PersonInfoListViewController") as! PersonInfoListViewController
            objPersonInfoListViewController.isCardList = true
            self.revealViewController()?.pushFrontViewController(objPersonInfoListViewController, animated: true)
        }
        else if strTitle == SideMenuTitle.personDocument.selectedString() {
            let objProofDisplayViewController:ProofDisplayViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "ProofDisplayViewController") as! ProofDisplayViewController
            self.revealViewController()?.pushFrontViewController(objProofDisplayViewController, animated: true)
        }
        else if strTitle == SideMenuTitle.biographic.selectedString() {
            let objzBiogrphyViewController:BioGraphyDisplayViewController = UIStoryboard(name: BiographyStoryBoard, bundle: nil).instantiateViewController(identifier: "BioGraphyDisplayViewController") as! BioGraphyDisplayViewController
            self.revealViewController()?.pushFrontViewController(objzBiogrphyViewController, animated: true)
        }
        else if strTitle == SideMenuTitle.restoreData.selectedString() {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to take back up from icloude".localized() + "?", ok: { (isSuccess) in
                self.deleteDB(isDelete: false)
            }, isCancel: true) { (isFalied) in
            }
        }
        else if strTitle == SideMenuTitle.deleteAccount.selectedString() {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to delete Account".localized() + " " + "?", ok: { (isSucccess) in
                self.deleteDB(isDelete: true)
            }, isCancel: true) { (isFailed) in
            }
        }
        else {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to Logout".localized() + " " + "?", ok: { (isSucces) in
                self.moveToMainPage()
            }, isCancel: true) { (isTrue) in
                
            }
        }
    }
    
    func moveToMainPage() {        
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        self.view.window?.rootViewController = initialViewController
    }
    func deleteDB(isDelete:Bool) {
        let viewController = UIStoryboard(name:InvitationStoryBoard , bundle: nil).instantiateViewController(identifier: "LoaderNavigation")
            isFromDelete = isDelete
            isFromSideMenu = true
        self.view.window?.rootViewController = viewController
    }
}

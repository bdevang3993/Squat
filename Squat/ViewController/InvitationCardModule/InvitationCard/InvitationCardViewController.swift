//
//  InvitationCardViewController.swift
//  Squat
//
//  Created by devang bhavsar on 19/02/22.
//

import UIKit
import Floaty
import Localize_Swift

class InvitationCardViewController: UIViewController {
    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var imgDiya1: UIImageView!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var imgDiya2: UIImageView!
    @IBOutlet weak var btnImage: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewTableHeader: UIView!
    var attributedString:NSAttributedString?
    var objInvitationCard = InvitationCardViewModel()
    var objImagePickerViewModel = ImagePickerViewModel()
    var imageData = Data()
    var floaty = Floaty()
    var playStoreURL:String = ""
    var isFromTervi:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if objInvitationCard.arrIteamList.count > 0 {
            self.tblDisplayData.isHidden = false
            lblNoDataFound.isHidden = true
        } else {
            self.tblDisplayData.isHidden = true
            lblNoDataFound.isHidden = false
        }
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.objInvitationCard.fetchPersonId()
        self.configureData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    @objc func setUpText() {
        self.setUpCustomField()
    }
    
    func setUpCustomField() {
        DispatchQueue.main.async {
            self.floaty.removeFromSuperview()
            self.floaty = Floaty()
            self.objInvitationCard.setHeaderView(headerView: self.viewHeader)
            self.configureData()
        }
    }
    func configureData() {
        lblNoDataFound.text = "No data found".localized()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewTableHeader.frame = CGRect(x: viewTableHeader.frame.origin.x, y: viewTableHeader.frame.origin.y, width: viewTableHeader.frame.width, height: 400)
            viewTableHeader.layoutIfNeeded()
        }
        
        if let imageData = UserDefaults.standard.value(forKey: kProfileImage) {
            imgLogo.image = UIImage(data: imageData as! Data)
        }
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        objInvitationCard.fetchMemberId()
        self.tblDisplayData.rowHeight = UITableView.automaticDimension
        self.tblDisplayData.estimatedRowHeight = 100.0
        self.objInvitationCard.isFromTervi = isFromTervi
        self.objInvitationCard.setHeaderView(headerView: viewHeader)
        self.objInvitationCard.tableView = self.tblDisplayData
        self.objInvitationCard.viewController = self
        let strAppName = Bundle.main.infoDictionary!["CFBundleName"] as! String
        playStoreURL = "https://apps.apple.com/India/app/\(strAppName)/id1611183134"
        let newDownloadString:String = "Note: If you want to install this app then download from App Store, URL:".localized()
        let attributedString = NSMutableAttributedString(string: "\(newDownloadString) \(playStoreURL)")
        attributedString.addAttribute(.link, value: playStoreURL, range: NSRange(location: newDownloadString.length + 1, length: playStoreURL.count))
        self.lblNote.attributedText = attributedString
        self.layoutFAB()
    }
    
    @IBAction func btnImageClicked(_ sender: Any) {
        self.moveToImage()
    }
    
    @objc func setUpData() {
        let objInvitationData:InvitationDescriptionViewController = UIStoryboard(name: InvitationStoryBoard, bundle: nil).instantiateViewController(identifier: "InvitationDescriptionViewController") as! InvitationDescriptionViewController
        objInvitationData.isFromTervi = isFromTervi
        if objInvitationCard.isFromEdit{
            if !isFromTervi {
                objInvitationData.objInvitationDescriptionModel.arrFamilyList = objInvitationCard.arrMemberList
            }
            objInvitationData.objInvitationDescriptionModel.arrAllItems = objInvitationCard.arrIteamList
            objInvitationData.isFromEdit = true
        }
        objInvitationData.modalPresentationStyle = .overFullScreen
        objInvitationData.selectedDetail = {[weak self] (detail,familyMember) in
            self?.objInvitationCard.arrIteamList = detail
            self?.objInvitationCard.arrMemberList = familyMember
            if detail.count > 0 {
                self?.tblDisplayData.isHidden = false
                self?.lblNoDataFound.isHidden = true
            }
//            self?.objInvitationCard.tableView = self?.tblDisplayData
            if self!.isFromTervi {
                self?.objInvitationCard.setUpDataForTervi()
            } else {
                self?.objInvitationCard.setUpDataOnCard()
            }
            self?.tblDisplayData.isHidden = false
        }
        self.present(objInvitationData, animated: true, completion: nil)
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

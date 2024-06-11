//
//  BioGraphyDisplayViewController.swift
//  Squat
//
//  Created by devang bhavsar on 19/03/22.
//

import UIKit

class BioGraphyDisplayViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var wheelView: ALRadialMenu!
    @IBOutlet weak var bottonView: RoundBottomView!
    var objBioGraphyDisplayViewModel = BioGraphyViewModel()
    
    @IBOutlet weak var btnRecording: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func configureData() {
        objBioGraphyDisplayViewModel.setHeaderView(headerView: viewHeader)
       // self.view.insertSubview(setUpBackgroundImage(imageName: "Logo"), at: 0)
        self.wheelView.buttonClickedEvent = {[weak self] result in
            DispatchQueue.main.async {
                if result != 100 {
                    self?.presentSelectedImage(index: result)
                } else {
                    self?.setUpUserList()
                }
            }
        }
        self.objBioGraphyDisplayViewModel.updateAllData = {[weak self] value in
            self!.wheelView.generateButtons(items: items, centerItem: GlovoItem(image:#imageLiteral(resourceName: "user"), text: value))
            self?.wheelView.presentInView()
          
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        objBioGraphyDisplayViewModel.setUpAllData()
        self.configureData()
       // self.wheelView.presentInView()
    }
    
    @IBAction func btnInformationClicked(_ sender: Any) {
        let objImageDisplayViewController:ImageDisplayViewController = UIStoryboard(name: BiographyStoryBoard, bundle: nil).instantiateViewController(identifier: "ImageDisplayViewController") as! ImageDisplayViewController
        objImageDisplayViewController.isFromImageDisplay = false
        objImageDisplayViewController.updateDatabase = {[weak self] id in
            self?.wheelView.subviews.forEach({ $0.removeFromSuperview()})
            self!.configureData()
            self!.objBioGraphyDisplayViewModel.personId = id
            self!.objBioGraphyDisplayViewModel.fetchAllData()
        }
        objImageDisplayViewController.modalPresentationStyle = .overFullScreen
        self.present(objImageDisplayViewController, animated: true, completion: nil)
    }
    
    
    func setUpUserList() {
        let objPesonInfo:PersonInfoViewController = UIStoryboard(name: BiographyStoryBoard, bundle: nil).instantiateViewController(identifier: "PersonInfoViewController") as! PersonInfoViewController
        objPesonInfo.updateBioGraphyValue = {[weak self] result in
            DispatchQueue.main.async {
                MBProgressHub.showLoadingSpinner(sender: (self?.view)!)
                self?.wheelView.glovoViews.removeAll()
                self?.wheelView.subviews.forEach({ $0.removeFromSuperview()})
                self!.objBioGraphyDisplayViewModel.personId = result.personId
                self!.configureData()
               self!.objBioGraphyDisplayViewModel.fetchAllData()
                MBProgressHub.dismissLoadingSpinner((self?.view)!)
            }
        }
        objPesonInfo.modalPresentationStyle = .overFullScreen
        self.present(objPesonInfo, animated: true, completion: nil)
    }
    
    func presentSelectedImage(index:Int) {
        let objBubbleDetails:BubbleDetailViewController = UIStoryboard(name: BiographyStoryBoard, bundle: nil).instantiateViewController(identifier: "BubbleDetailViewController") as! BubbleDetailViewController
        objBubbleDetails.selectedItem = items[index]
        objBubbleDetails.selectedIndex = index
        objBubbleDetails.biographyData = objBioGraphyDisplayViewModel.arrBiographyData[index]
        objBubbleDetails.modalPresentationStyle = .overFullScreen
        self.present(objBubbleDetails, animated: true, completion: nil)
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

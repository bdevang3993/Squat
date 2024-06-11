//
//  BubbleDetailViewController.swift
//  ImageAnimationWithText
//
//  Created by devang bhavsar on 12/03/22.
//

import UIKit
class BubbleDetailViewController: UIViewController {
    @IBOutlet weak var wheelView: ALRadialMenu!
    var selectedItem:GlovoItem?
    var items = [GlovoItem]()
    var biographyData = BiographyData(personId: 0, personPlaceName: "", personDescription: "", personImage: "", personName: "")
    var selectedIndex:Int = 0
    @IBOutlet weak var lblDescription: LTMorphingLabel!
    var objBubbleDetailsModel = BubbleDetailViewModel()
//    var allData = ["Attend the babary on 2015","Attend the babary on 2015","Attend Marriage on 2018","Attend Birthday on 2022","Attend Birthday on 2021"]
//    var arrDescription = ["I have attend the babary of Het with the My borther and his Faimily in Samdaji in Gujarat.","I have attend the babary of Het with the My borther and his Faimily in Samdaji in Gujarat.","Attend the marriage of my nephew in Ahmedabad with all my family","Attend the marriage of my nephew in Nadaid with good resturent and enjoy a lot","Attend my birthday party with all my derani and nephew"]
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var lblTitle: LTMorphingLabel!
    var imageV = UIImageView()
    var button = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.objBubbleDetailsModel.biographyData = self.biographyData
        self.objBubbleDetailsModel.viewController = self
        self.objBubbleDetailsModel.tableView = self.tblDisplayData
        self.view.insertSubview(setUpBackgroundImage(imageName: "Logo"), at: 0)
        items.removeAll()
        items.append(selectedItem!)
        wheelView.generateButtons(items: items, centerItem:nil)
        if let effect = LTMorphingEffect(rawValue: 5) {
            lblTitle.morphingEffect = effect
            lblTitle.text = biographyData.personName
        }
        self.setUpTitle(strValue: biographyData.personDescription, effectId: 3)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.wheelView.buttonClickedEvent = {[weak self] result in
            DispatchQueue.main.async {
                print("selected tag = \(result)")
                self?.imageDisplayView(index: result, name: "")
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.objBubbleDetailsModel.fetchAllData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
            wheelView.presentInView()
    }
    
    func imageDisplayView(index:Int,name:String) {
        self.imageV.removeFromSuperview()
        self.button.removeFromSuperview()
        imageV = UIImageView(frame: CGRect(x: 50, y: 100, width: 150, height: 150))
        button = UIButton(frame: CGRect(x: (screenWidth/2) + (screenWidth/4), y: screenHeight/3 , width: 50, height: 50))
        button.tintColor = UIColor(displayP3Red: 119.0, green: 172.0, blue: 236.0, alpha: 1.0)
        button.setImage(UIImage(named: "close"), for: .normal)
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
            imageV.center = view.center
            imageV.image = UIImage(named: name)//UIImage(named: "1", in: Bundle(for: type(of: self)), compatibleWith: nil)
            view.addSubview(imageV)
        UIView.animate(withDuration: 6.0) {
            self.imageV.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { (isSuccess) in
            self.view.addSubview(self.button)
        }

    }
    @IBAction func btnDescriptionClicked(_ sender: UIButton) {
        let description = biographyData.personDescription
        let alertController = UIAlertController(title: "Detail".localized(), message:description, preferredStyle: .alert)
        // Create the actions
        let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func setUpTitle(strValue:String,effectId:Int) {
        if let effect = LTMorphingEffect(rawValue: effectId) {
            lblDescription.morphingEffect = effect
            lblDescription.text = "\u{2022} \(strValue)"
            lblDescription.sizeToFit()
        }
    }
    @objc func cancel() {
        self.imageV.removeFromSuperview()
        self.button.removeFromSuperview()
    }
    @IBAction func btnBackClicked(_ sender: Any) {
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
extension BubbleDetailViewController:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objBubbleDetailsModel.arrAllImages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as! CustomTableViewCell
        cell.viewContent.backgroundImage = objBubbleDetailsModel.arrAllImages[indexPath.row]
        cell.layoutIfNeeded()
        return cell
     }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            cell.layoutIfNeeded()
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objBubbleDetailsModel.setUpDelete(index: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objBubbleDetailsModel.openImage(index: indexPath.row)
    }
}

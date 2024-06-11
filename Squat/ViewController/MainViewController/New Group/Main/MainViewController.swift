//
//  MainViewController.swift
//  Squat
//
//  Created by devang bhavsar on 18/02/22.
//

import UIKit
import AVFoundation
import MediaPlayer
class MainViewController: UIViewController {
    @IBOutlet weak var imgFlowerShow: UIImageView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgPerson: UIImageView!
    @IBOutlet weak var btnPhoto: UIButton!
    @IBOutlet weak var imgDhup: UIImageView!
    @IBOutlet weak var imgTable: UIImageView!
    @IBOutlet weak var imgThali: UIImageView!
    @IBOutlet weak var imgMoney: UIImageView!
    @IBOutlet weak var imgDiva: UIImageView!
    var objMainViewModel = MainViewModel()
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDOB: UILabel!
    @IBOutlet weak var lblDOD: UILabel!
    @IBOutlet weak var btnPlayList: UIButton!
    @IBOutlet weak var btnStart: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var btnRose: UIButton!
    @IBOutlet weak var btnPrevious: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var btnNeck: UIButton!
    @IBOutlet weak var imageSliderCollectionView: UICollectionView!
    var userDefault = UserDefaults.standard
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var timer:Timer?
    var imageData = Data()
    var objImagePickerViewModel = ImagePickerViewModel()
    var mp3Index:Int = 0
    var imgMain:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewWillAppear(_ animated: Bool) {
        if let name = userDefault.value(forKey: kName) {
            self.lblName.text = (name as! String)
        }
        if let dob = userDefault.value(forKey: kDob) {
            self.lblDOB.text = (dob as! String)
        }
        if let dod = userDefault.value(forKey: kDod) {
            self.lblDOD.text = (dod as! String)
        }
        perform(#selector(self.setUpImage), with: nil, afterDelay: 0.2)

    }
    func configureData() {
        imgFlowerShow.isHidden = true
        objMainViewModel.setHeaderView(headerView: viewHeader)
        imgMoney.layer.cornerRadius = 60.0
        imgMoney.layer.masksToBounds = true
        imgDhup.loadGif(name: "Agarbati")
        imgDiva.loadGif(name: "Diya")
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        imgMain = UIImage(named: "logo")
        lblSongTitle.text = "Song Name".localized()
        self.setUpFrameImage()
        imageSliderCollectionView.delegate = self
        imageSliderCollectionView.dataSource = self
        imageSliderCollectionView.automaticallyAdjustsScrollIndicatorInsets = false
        imageSliderCollectionView.isHidden = true
        self.revealViewController()?.tapGestureRecognizer()
    }
    
    @objc func setUpImage()  {
        if let profileImage = userDefault.value(forKey: kProfileImage) {
            self.imgPerson?.image = UIImage(data: profileImage as! Data)//(profileImage as! Data)
            imgMain = self.imgPerson?.image
            self.setUpFrameImage()
        }
    }
    func setUpFrameImage() {
        if let img = imgMain, let img2 = UIImage(named: "nackless") {
            let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
           // context!.setStrokeColor(UIColor.red.cgColor)
            context!.setFillColor(UIColor.clear.cgColor)
            context!.fill(rect)

            img.draw(in: rect, blendMode: .normal, alpha: 1.0)//normal
            img2.draw(in: CGRect(x: 0,y: 0,width: img.size.width, height: img.size.height), blendMode: .normal, alpha: 1.0)
            img2.withTintColor(.clear)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imgPerson.image = newImage
           // UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
        }
    }
    func mergeImages(index:Int)  {
        let nackImage = objMainViewModel.arrNack[index]
        if let img = imgMain, let img2 = nackImage {
            let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
            UIGraphicsBeginImageContextWithOptions(img.size, true, 0)
            let context = UIGraphicsGetCurrentContext()
           // context!.setStrokeColor(UIColor.red.cgColor)
            context!.setFillColor(UIColor.clear.cgColor)
            context!.fill(rect)

            img.draw(in: rect, blendMode: .normal, alpha: 1.0)//normal
            img2.draw(in: CGRect(x: 0,y: 0,width: img.size.width, height: img.size.height), blendMode: .normal, alpha: 1.0)
            img2.withTintColor(.clear)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            imgPerson.image = newImage
           // UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
            imageSliderCollectionView.delegate = self
            imageSliderCollectionView.dataSource = self
            imageSliderCollectionView.isHidden = true
        } else {
            Alert().showAlert(message: "please select the person image first".localized(), viewController: self)
        }
    }
    
    @objc func enterDetail() {
        let objSignUp:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objSignUp.modalPresentationStyle = .overFullScreen
        objSignUp.selectedType = SelectedViewModel.detail.strSelectedTitle()
        objSignUp.personInformation = {[weak self] (name,dob,dod) in
            self?.lblName.text = name
            self?.lblDOB.text = dob
            self?.lblDOD.text = dod
            self!.userDefault.setValue(name, forKey: kName)
            self!.userDefault.set(dob, forKey: kDob)
            self?.userDefault.set(dod, forKey: kDod)
            self?.userDefault.synchronize()
        }
        self.present(objSignUp, animated: true, completion: nil)
    }
    @IBAction func choosePhotoClicked(_ sender: Any) {
        self.moveToImage()
    }
    @IBAction func btnPlayListClicked(_ sender: Any) {
        
    }
    
    @IBAction func btnNeckClicked(_ sender: Any) {
        if imageSliderCollectionView.isHidden == true {
            imageSliderCollectionView.isHidden = false
        } else {
            imageSliderCollectionView.isHidden = true
        }
        
        imageSliderCollectionView.reloadData()
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        if mp3Index > 0 {
            mp3Index -= 1
        } else {
            mp3Index = self.objMainViewModel.arrMP3FileList.count - 1
        }
        self.btnStartClicked(AnyClass.self)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        if self.objMainViewModel.arrMP3FileList.count - 1  > mp3Index {
            mp3Index += 1
        } else {
            mp3Index = 0
        }
        self.btnStartClicked(AnyClass.self)
    }
    
    @IBAction func btnRoseClicked(_ sender: Any) {
        btnRose.isHidden = true
        imgFlowerShow.isHidden = false
        imgFlowerShow.loadGif(name: "ShowerFlower")
        timer  = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.stopAnimationImage), userInfo: nil, repeats: false)
    }
    @objc func stopAnimationImage() {
        imgFlowerShow.image = UIImage(named: "")
        imgFlowerShow.isHidden = true
        btnRose.isHidden = false
        timer?.invalidate()
    }
    @IBAction func btnStartClicked(_ sender: Any) {
        let url = Bundle.main.url(forResource: self.objMainViewModel.arrMP3FileList[mp3Index], withExtension: "mp3")!
        self.lblSongTitle.text = self.objMainViewModel.arrMP3FileList[mp3Index]
//        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        let playerItem:AVPlayerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        if player?.rate == 0 {
            player?.play()
        }
    }
    
    @IBAction func btnStopClicked(_ sender: Any) {
        player?.pause()
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

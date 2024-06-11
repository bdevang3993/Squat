//
//  ViewController.swift
//  Squat
//
//  Created by devang bhavsar on 16/02/22.
//

import UIKit
import LocalAuthentication
import Localize_Swift
import FacebookLogin
import FBSDKLoginKit
import AuthenticationServices
class ViewController: UIViewController {
    @IBOutlet weak var loginProviderStackView: UIStackView!
    @IBOutlet weak var lblSIgnUp: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var lblNoAccount: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var btnFace: UIButton!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    var objLoginViewModel = LoginViewModel()
    var objUserInfoDetailQuery = UserInfoDetailQuery()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpConfigureData()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    func setUpConfigureData() {
        self.setupLoginProviderView()
        if let token = AccessToken.current,
               !token.isExpired {
               // User is logged in, do work such as go to next view controller.
           }
        self.viewMain.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.txtMobileNumber.delegate = self
        self.txtMobileNumber.placeholder = "Email Id".localized() + "/" + "Mobile Number".localized()
        self.txtPassword.placeholder  = "Password".localized()
        self.btnLogin.setUpButton()
        self.btnLogin.setTitle("SAVE".localized(), for: .normal)
        self.lblOR.text = "OR".localized()
        self.lblForgotPassword.text = "Forgot Password".localized()
        self.lblNoAccount.text = "Don't have an account".localized()
        self.lblSIgnUp.text = "Signup here".localized()
        
        objLoginViewModel.viewController = self
        objLoginViewModel.fetchData { (isSuccess) in
        }
        guard let value = UserDefaults.standard.value(forKey: kSelectedLanguage) else {
            self.openLangaugeSelectrion()
            return
        }
    }
    //Set up Apple Login
    private func setupLoginProviderView() {
        // Set button style based on device theme
        let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .white : .black
        
        // Create and Setup Apple ID Authorization Button
        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)
        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        
        // Add Height Constraint
        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 44)
        authorizationButton.addConstraint(heightConstraint)
        
        //Add Apple ID authorization button into the stack view
        loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @objc private func handleLogInWithAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func openLangaugeSelectrion() {
        let objForgotPasswordViewController:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        objForgotPasswordViewController.isFromLanguage = true
        objForgotPasswordViewController.modalPresentationStyle = .overFullScreen
        self.present(objForgotPasswordViewController, animated: true, completion: nil)
    }
    
    @objc func setUpText() {
        self.setUpCustomField()
    }
    
    func setUpCustomField() {
        DispatchQueue.main.async {
            self.btnLogin.setTitle("SAVE".localized(), for: .normal)
            self.lblOR.text = "OR".localized()
            self.lblForgotPassword.text = "Forgot Password".localized()
            self.lblNoAccount.text = "Don't have an account".localized()
            self.lblSIgnUp.text = "Signup here".localized()
        }
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
        let userDefault = UserDefaults.standard
        var userData:String = ""
        if txtMobileNumber.text == "bdevang86@gmail.com" && txtPassword.text == "123456" {
            objLoginViewModel.checkForDataExist { (isSuccess) in
                if !isSuccess {
                    DispatchQueue.main.async {
                        self.objLoginViewModel.updateData = {[weak self] in
                            self!.moveToNextViewController()
                        }
                        self.objLoginViewModel.setUpDatabaseForExsitngUser()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.moveToNextViewController()
                    }
                }
            }
            return
        }
        if txtMobileNumber.text!.isEmpty {
            Alert().showAlert(message: "please enter the number or email id".localized(), viewController: self)
            return
        } else if !validatePhoneNumber(value: txtMobileNumber.text!) {
            guard let email = userDefault.value(forKey: kEmailId) else {
                Alert().showAlert(message: "please sign up".localized(), viewController: self)
                return
            }
            userData = email as! String
            // Alert().showAlert(message: "please provide valied mobile number", viewController: self)
        }else {
            let userDefault = UserDefaults.standard
            guard let mobileNumber = userDefault.value(forKey: kNumber)  else {
                Alert().showAlert(message: "please sign Up".localized(), viewController: self)
                return
            }
            userData = mobileNumber as! String
        }
        if userData == txtMobileNumber.text! {
            userDefault.set(true, forKey:kLogin)
            userDefault.synchronize()
            self.moveToNextViewController()
        } else {
            Alert().showAlert(message: "please provide valied mobile number".localized(), viewController: self)
        }
    }
    
    func moveToNextViewController() {
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = initialViewController
    }

    @IBAction func btnFaceClicked(_ sender: Any) {
        self.loginUsingBioMatrix()
    }
    
    func loginUsingBioMatrix() {
        let userDefault = UserDefaults.standard
        var strNumber:String = ""
        if let newNumber = userDefault.value(forKey: kEmailId) {
            strNumber = newNumber as! String
        }
        if strNumber.count > 2 {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (isvalied, error) in
                    if isvalied {
                        DispatchQueue.main.async { [unowned self] in
                         self.moveToNextViewController()
                        }
                    }else {
                        DispatchQueue.main.async {
                            Alert().showAlert(message: "\(error.debugDescription)", viewController: self)
                        }
                    }
                })
            } else {
                Alert().showAlert(message: "please check allowcation of face recognization or thumbnail".localized(), viewController: self)
            }
        } else {
            Alert().showAlert(message: "please we don't have credential so first time login with email and password".localized(), viewController: self)
        }
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
        let objSignUpViewController:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objSignUpViewController.modalPresentationStyle = .overFullScreen
        self.present(objSignUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: UIButton) {
        let objForgotPassword:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        objForgotPassword.modalPresentationStyle = .overFullScreen
        self.present(objForgotPassword, animated: true, completion: nil)
    }
    
    @IBAction func btnFacebookClicked(_ sender: Any) {
        let fbLoginManager : LoginManager = LoginManager()
        
        fbLoginManager.logIn(permissions:["email","public_profile"], from: self, handler: {(result, error) -> Void in
            
            print("\n\n result: \(String(describing: result))")
            print("\n\n Error: \(String(describing: error))")
            
            if (error == nil)
            {
                if let fbloginresult = result
                {
                    if(fbloginresult.isCancelled)
                    {
                        //Show Cancel alert to the user
                        let alert = UIAlertController(title: "Facebook login", message: "User pressed cancel button", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {    (action:UIAlertAction!) in
                            //print("you have pressed the ok button")
                            
                        }))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else
                    
                    {
                        print("going to getFBLoggedInUserData.. ")
                        self.getFBLoggedInUserData()
                        
                    }
                }
                
            }
        })
        
        
        
        
        
        
        
        
        
        
//        fbLoginManager.logIn(permissions: [.publicProfile,.email], viewController: self) { (result) in
//            switch result {
//            case .cancelled:
//                Alert().showAlert(message: "Cancel Button Clicked", viewController: self)
//                break
//            case .success(granted: let granted, declined: let declined, token: let token):
//                let params = ["fields" : "id, name, first_name, last_name, picture.type(large), email "]
//                let graphRequest = GraphRequest.init(graphPath: "/me", parameters: params)
//                let Connection = GraphRequestConnection()
//                Connection.add(graphRequest) { (Connection, result, error) in
//                    let info = result as! [String : AnyObject]
//                    let email = info["email"] as! String
//                    let name = info["name"] as! String
//                    let picture = info["picture"] as! [String:Any]
//                    print("all Json = \(picture)")
//                    let imageURl = picture["data"] as! [String:Any]
//                    let url = imageURl["url"] as! String
//                    self.checkforSignUp(name: name, email: email, url: url)
//                    print(info["name"] as! String)
//                }
//                Connection.start()
//                break
//            case .failed(_):
//                break
//            }
//        }
    }
    
    //We get here required data from facebook SDK
      func getFBLoggedInUserData()
      {
          var nameUser:String = ""
          var emailID:String = ""
          var imgURL:String = ""
          let graphRequest : GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields":"email,first_name,name,picture.type(normal)"])
          
          graphRequest.start { connection, result, error in
              if error != nil {

              }
              else if let resultDic = result as? [String:Any] {
                  print("Result Data = \(resultDic)")
                  if let name = resultDic["name"]  {
                      nameUser = name as! String
                  }
                  if let email = resultDic["email"]  {
                      emailID = email as! String
                  }
                  if let fname = resultDic["first_name"] {
                      nameUser = nameUser + " " + (fname as! String)
                  }
                  if let id = resultDic["id"] {
                      //self.returnUserProfileImage()
                      let userId = id as! String
                  }
                  let pictureData = resultDic["picture"] as! [String:Any]
                  let allData = pictureData["data"] as! [String:Any]
                  let url = allData["url"] as! String
                  imgURL = url
                  //self.returnUserProfileImage(url: url)
                  self.checkforSignUp(name: nameUser, email: emailID, url: imgURL)
                  
              }
          }
      }
    func checkforSignUp(name:String,email:String,url:String) {
        let imageData = try? Data(contentsOf: URL(string: url)!)
        objUserInfoDetailQuery.fetchDataByEmail(emailId: email) { (result) in
            if let emailid = result["emailId"] {
                if emailid as! String == email {
                    self.moveToNextViewController()
                }
            } else {
                self.setUpSignUp(emailId: email, name: name, imagURl: imageData!)
            }

        } failure: { (isFailed) in
            self.setUpSignUp(emailId: email, name: name, imagURl: imageData!)
        }
    }
    func setUpSignUp(emailId:String,name:String,imagURl:Data) {
        DispatchQueue.main.async {
         MBProgressHub.showLoadingSpinner(sender:self.view)
            self.objUserInfoDetailQuery.saveinDataBase(strName: name, strAddress: "", strMobileNumber: "", strEmailId: emailId, strPassword:"", strPhoto: imagURl) { (isSucccess) in
                MBProgressHub.dismissLoadingSpinner(self.view)
                if isSucccess {
                    let userDefault = UserDefaults.standard
                    userDefault.set(true, forKey:kLogin)
                    userDefault.set(emailId, forKey:kEmailId)
                    userDefault.set("", forKey:kPassword)
                    userDefault.synchronize()
                    self.moveToNextViewController()
                }else {
                    Alert().showAlert(message: "please try again".localized(), viewController: self)
                }
            }
            
        }
    }
   
}

extension ViewController : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        Alert().showAlert(message: error.localizedDescription, viewController: self)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
        
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            KeychainItem.currentUserIdentifier = appleIDCredential.user
            KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
            KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
            KeychainItem.currentUserEmail = appleIDCredential.email
            let userId = appleIDCredential.user
            let name = appleIDCredential.fullName?.description
            let email = appleIDCredential.email
            let userStatus = appleIDCredential.realUserStatus.rawValue
            
            if let identityTokenData = appleIDCredential.identityToken,
                let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
//                print("Identity Token \(identityTokenString)")
            }
            let userDefault = UserDefaults.standard
            userDefault.setValue(name, forKey: kName)
//            userDefault.setValue(email, forKey: kEmail)
//            userDefault.setValue("", forKey: kimage)
            userDefault.set(true, forKey: kLogin)
            userDefault.synchronize()
            //Show Home View Controller
            DispatchQueue.main.async {
                self.setUpSignUp(emailId: email!, name: name!, imagURl: Data())
            }
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain.".localized() + " \n\n Username".localized() + " : " + "\(username)\n" + "Password".localized() + " : " + " \(password)"
                Alert().showAlert(message: message, viewController: self)
            }
        }
    }
    
    
}

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

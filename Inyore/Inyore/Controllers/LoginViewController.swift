//
//  LoginViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import WebKit
import AuthenticationServices


class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var lblForgetPassword: UILabel!
    
    @IBOutlet weak var lblGuidLines: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    
    var myUser: [User]? {didSet {}}
    
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    
    var webView = WKWebView()
    var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        let taplblForgetPassword = UITapGestureRecognizer.init(target: self, action: #selector(self.tapForgetPassword))
        self.lblForgetPassword.addGestureRecognizer(taplblForgetPassword)
        
        let taplblCommunityGuide = UITapGestureRecognizer.init(target: self, action: #selector(self.tapCommunityGuid))
        self.lblGuidLines.addGestureRecognizer(taplblCommunityGuide)
        
        let taplblTerms = UITapGestureRecognizer.init(target: self, action: #selector(self.tapTerms))
        self.lblTerms.addGestureRecognizer(taplblTerms)
        
        let taplblPrivacyPolicy = UITapGestureRecognizer.init(target: self, action: #selector(self.tapPrivacyPolicy))
        self.lblPrivacyPolicy.addGestureRecognizer(taplblPrivacyPolicy)
    }
    
    //MARK:- Utility Methods
    
    //MARK:- tap gestures
    @objc func tapCommunityGuid(){
        
        let communityGuidlineVC = self.storyboard?.instantiateViewController(withIdentifier: "communityGuidlineVC") as! CommunityGuidlineViewController
        navigationController?.pushViewController(communityGuidlineVC, animated: true)
    }
    
    @objc func tapTerms(){
        
        let terms2VC = self.storyboard?.instantiateViewController(withIdentifier: "terms2VC") as! Terms2ViewController
        navigationController?.pushViewController(terms2VC, animated: true)
    }
    
    @objc func tapPrivacyPolicy(){
        
        let privacyPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVC") as! PrivacyPolicyViewController
        navigationController?.pushViewController(privacyPolicyVC, animated: true)
    }
    
    //MARK:- Button Action
    @IBAction func btnLinkedInLoginAction(_ sender: UIButton) {
        
        self.linkedInAuthVC()
    }
    
    @IBAction func btnAppleLoginAction(_ sender: UIButton) {
        
        self.signInWithApple()
    }
    
    @objc func tapForgetPassword(){
        
        let resetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "resetPasswordVC") as! ResetPasswordViewController
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        if AppUtility.shared.isEmpty(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_email", comment: ""), delegate: self)
            return
        }
        if !AppUtility.shared.IsValidEmail(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_valid_email", comment: ""), delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtPassword.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_password", comment: ""), delegate: self)
            return
        }
        if  self.txtPassword.text!.count < 8{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_password_length", comment: ""), delegate: self)
            return
        }
        
        self.callUserLoginAPI()
        
    }
    
    @IBAction func btnContinueWithEmailAction(_ sender: UIButton) {
        
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    //MARK: API Methods
    func callUserLoginAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        let app_id = UserDefaults.standard.value(forKey: "app_id") as? String ?? ""
        let fcm_key = UserDefaults.standard.value(forKey: "fcm_key") as? String ?? ""
        
        let param = ["email": self.txtEmail.text!, "password": self.txtPassword.text!, "app_id": app_id, "fcm_key": fcm_key]
        APIHandler.sharedInstance.userLogin(params: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        let user = data["user"] as! NSDictionary
                        print("User: ", user)
                        
                        if user["is_activated"] as! Int == 1{
                            
                            let usr = User()
                            
                            usr.id = user["id"] as? Int
                            usr.full_username = user["full_username"] as? String
                            usr.usr_username_id = user["usr_username_id"] as? Int
                            usr.usr_first_name = user["usr_first_name"] as? String
                            usr.usr_last_name = user["usr_last_name"] as? String
                            usr.email = user["email"] as? String
                            
                            usr.remember_token = user["remember_token"] as? String
                            usr.api_token = user["api_token"] as? String
                            
                            usr.usr_status = user["usr_status"] as? String
                            
                            self.myUser = [usr]
                            
                            if User.saveUserToArchive(user: self.myUser!){
                                
                                if user["usr_status"] as! String == "1"{
                                    
                                    let data = UserDefaults.standard.value(forKey: "userAgreeTerms")
                                    if data != nil{
                                        
                                        let story = UIStoryboard(name: "Main", bundle: nil)
                                        let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                                        tabbarVC.modalPresentationStyle = .fullScreen
                                        self.present(tabbarVC, animated: true, completion: nil)
                                    }
                                    else{
                                        
                                        let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "termsVC") as! TermsViewController
                                        self.navigationController?.pushViewController(termsVC, animated: true)
                                    }
                                    
                                }
                                else{
                                    
                                    let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "userDetailVC")
                                        as! UserDetailViewController
                                    self.navigationController?.pushViewController(userDetailVC, animated: true)
                                }
                            }
                            
                        }
                        else{
                            
                            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please check your email to activate your account and then login here again!", delegate: self)
                        }
                        
                    }
                }
                else{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: msg, delegate: self)
                }
            }
            else{
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    func callsocialLoginAPI(email: String){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        let app_id = UserDefaults.standard.value(forKey: "app_id") as? String ?? ""
        let fcm_key = UserDefaults.standard.value(forKey: "fcm_key") as? String ?? ""
        
        let param = ["email": email, "app_id": app_id, "fcm_key": fcm_key]
        
        APIHandler.sharedInstance.linkedInLogin(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        //                        let user = data["user"] as! NSDictionary
                        //                        print("User: ", user)
                        
                        if data["is_activated"] as! Int == 1{
                            
                            let usr = User()
                            
                            usr.id = data["id"] as? Int
                            usr.usr_username_id = data["usr_username_id"] as? Int
                            usr.full_username = data["full_username"] as? String
                            usr.usr_first_name = data["usr_first_name"] as? String
                            usr.usr_last_name = data["usr_last_name"] as? String
                            usr.email = data["email"] as? String
                            
                            usr.remember_token = data["remember_token"] as? String
                            usr.api_token = data["api_token"] as? String
                            
                            usr.usr_status = data["usr_status"] as? String
                            
                            self.myUser = [usr]
                            
                            if User.saveUserToArchive(user: self.myUser!){
                                
                                if data["usr_status"] as! String == "1"{
                                    
                                    let data = UserDefaults.standard.value(forKey: "userAgreeTerms")
                                    if data != nil{
                                        
                                        let story = UIStoryboard(name: "Main", bundle: nil)
                                        let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                                        tabbarVC.modalPresentationStyle = .fullScreen
                                        self.present(tabbarVC, animated: true, completion: nil)
                                    }
                                    else{
                                        
                                        let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "termsVC") as! TermsViewController
                                        self.navigationController?.pushViewController(termsVC, animated: true)
                                    }
                                    
                                }
                                else{
                                    
                                    let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "userDetailVC")
                                        as! UserDetailViewController
                                    self.navigationController?.pushViewController(userDetailVC, animated: true)
                                }
                            }
                            
                        }
                        else{
                            
                            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please check your email to activate your account and then login here again!", delegate: self)
                        }
                        
                    }
                }
                else{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: msg, delegate: self)
                }
            }
            else{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    func callAppleLoginAPI(unique_key: String, email: String){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        let app_id = UserDefaults.standard.value(forKey: "app_id") as? String ?? ""
        let fcm_key = UserDefaults.standard.value(forKey: "fcm_key") as? String ?? ""
        
        let param = ["unique_key": unique_key, "email": email, "app_id": app_id, "fcm_key": fcm_key]
        
        APIHandler.sharedInstance.appleLogin(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        if data["is_activated"] as! Int == 1{
                            
                            let usr = User()
                            
                            usr.id = data["id"] as? Int
                            usr.usr_username_id = data["usr_username_id"] as? Int
                            usr.full_username = data["full_username"] as? String
                            usr.usr_first_name = data["usr_first_name"] as? String
                            usr.usr_last_name = data["usr_last_name"] as? String
                            usr.email = data["email"] as? String
                            
                            usr.remember_token = data["remember_token"] as? String
                            usr.api_token = data["api_token"] as? String
                            
                            usr.usr_status = data["usr_status"] as? String
                            
                            self.myUser = [usr]
                            
                            if User.saveUserToArchive(user: self.myUser!){
                                
                                if data["usr_status"] as! String == "1"{
                                    
                                    let data = UserDefaults.standard.value(forKey: "userAgreeTerms")
                                    if data != nil{
                                        
                                        let story = UIStoryboard(name: "Main", bundle: nil)
                                        let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                                        tabbarVC.modalPresentationStyle = .fullScreen
                                        self.present(tabbarVC, animated: true, completion: nil)
                                    }
                                    else{
                                        
                                        let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "termsVC") as! TermsViewController
                                        self.navigationController?.pushViewController(termsVC, animated: true)
                                    }
                                    
                                }
                                else{
                                    
                                    let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "userDetailVC")
                                        as! UserDetailViewController
                                    self.navigationController?.pushViewController(userDetailVC, animated: true)
                                }
                            }
                            
                        }
                        else{
                            
                            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please check your email to activate your account and then login here again!", delegate: self)
                        }
                        
                    }
                }
                else{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: msg, delegate: self)
                }
            }
            else{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    //MARK:- linkedIn Auth
    func linkedInAuthVC() {
        
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
        ])
        
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.colorFromHex("#0072B1")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    //MARK:- Apple Login Auth
    func signInWithApple(){
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        }
        else{
            print("Erliar version")
        }
    }
    
    
    //MARK:- delegate method of Apple Login
    
    
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

extension LoginViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Start to load")
        AppUtility.shared.showLoader(message: "Please wait...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finish to load")
        AppUtility.shared.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        AppUtility.shared.hideLoader()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        AppUtility.shared.hideLoader()
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
                //AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                self.linkedInAccessToken = accessToken
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")
                self.linkedInId = linkedinId
                
                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                self.linkedInFirstName = linkedinFirstName
                
                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                self.linkedInLastName = linkedinLastName
                
                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!
                
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                self.linkedInProfilePicURL = linkedinProfilePic
                
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                
                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                
                DispatchQueue.main.async {
                    
                    self.callsocialLoginAPI(email: linkedinEmail)
                }
                
                //                DispatchQueue.main.async {
                //                    self.performSegue(withIdentifier: "detailseg", sender: self)
                //                }
            }
        }
        task.resume()
    }
    
    
}

@available(iOS 13.0, *)
extension LoginViewController: ASAuthorizationControllerDelegate{
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
            
            let key = userIdentifier
            let emailId = email ?? ""
            
            self.callAppleLoginAPI(unique_key: key, email: emailId)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        print("Error occured: ", error.localizedDescription)
    }
}


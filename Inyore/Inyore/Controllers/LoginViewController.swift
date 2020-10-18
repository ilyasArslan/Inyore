//
//  LoginViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var lblForgetPassword: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    
    var myUser: [User]? {didSet {}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        let taplblForgetPassword = UITapGestureRecognizer.init(target: self, action: #selector(self.tapForgetPassword))
        self.lblForgetPassword.addGestureRecognizer(taplblForgetPassword)
        
        let taplblSignUp = UITapGestureRecognizer.init(target: self, action: #selector(self.tapSignUp))
        self.lblSignUp.addGestureRecognizer(taplblSignUp)
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
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
        
        self.userLoginAPI()

    }
    
    @objc func tapForgetPassword(){
        
        let resetPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "resetPasswordVC") as! ResetPasswordViewController
        navigationController?.pushViewController(resetPasswordVC, animated: true)
    }
    
    @objc func tapSignUp(){
        
        let signUpVC = self.storyboard?.instantiateViewController(withIdentifier: "signUpVC") as! SignUpViewController
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    //MARK: API Methods
    func userLoginAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.userLogin(email: self.txtEmail.text!, password: self.txtPassword.text!) { (isSuccess, response) in
                        
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        let user = data["user"] as! NSDictionary
                        print("User: ", user)
                        
                        if user["is_activated"] as! Int == 1{
                            
                            let usr = User()
                            
                            usr.usr_username_id = user["usr_username_id"] as? Int
                            usr.usr_first_name = user["usr_first_name"] as? String
                            usr.usr_last_name = user["usr_last_name"] as? String
                            usr.email = user["email"] as? String
                            usr.api_token = user["api_token"] as? String
                            
                            usr.usr_status = user["usr_status"] as? String
                            
                            self.myUser = [usr]
                            
                            if User.saveUserToArchive(user: self.myUser!){
                                
                                if user["usr_status"] as! String == "1"{
                                    
                                    let story = UIStoryboard(name: "Main", bundle: nil)
                                    let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                                    tabbarVC.modalPresentationStyle = .fullScreen
                                    self.present(tabbarVC, animated: true, completion: nil)
                                    
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
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

//
//  SignUpViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var lblTerms_Conditions: UILabel!
    @IBOutlet weak var lblLogin: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        let taplblTerms = UITapGestureRecognizer.init(target: self, action: #selector(self.tapTerms))
        self.lblTerms_Conditions.addGestureRecognizer(taplblTerms)
        
        let taplblLogin = UITapGestureRecognizer.init(target: self, action: #selector(self.tapLogin))
        self.lblLogin.addGestureRecognizer(taplblLogin)
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    @IBAction func btnRegisterAction(_ sender: UIButton) {
        
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
        
        self.userRegisterAPI()
        
    }
    
    //MARK:- tap gestures
    @objc func tapTerms(){
        print("Terms Click")
    }
    
    @objc func tapLogin(){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: API Methods
    func userRegisterAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.userRegister(email: self.txtEmail.text!, password: self.txtPassword.text!) { (isSuccess, response) in
            
            print("Response: ", response)
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: msg, delegate: self)
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

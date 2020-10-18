//
//  ResetPasswordViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    //MARK: Outlets
    @IBOutlet weak var txtEmail: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
       
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetLinkAction(_ sender: UIButton) {
        
        if AppUtility.shared.isEmpty(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_email", comment: ""), delegate: self)
            return
        }
        if !AppUtility.shared.IsValidEmail(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_valid_email", comment: ""), delegate: self)
            return
        }
        
        self.callForgetPasswordAPI()
    }
    
    //MARK: API Methods
    func callForgetPasswordAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }

        let param = ["email": self.txtEmail.text!, "api_token": ""]
        
        APIHandler.sharedInstance.forgetPassword(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: msg, delegate: self)
                }
                else{
                    
                    let message = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
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

//
//  ContactViewController.swift
//  Inyore
//
//  Created by Arslan on 08/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import DropDown

class ContactViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet weak var txtFirstName: CustomTextField!
    @IBOutlet weak var txtLastName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtCompanyName: CustomTextField!
    
    @IBOutlet weak var btnSelectCompanySize: UIButton!
    @IBOutlet weak var txtCompanySize: CustomTextField!
    
    @IBOutlet weak var btnSelectCountry: UIButton!
    @IBOutlet weak var txtCountry: CustomTextField!
    
    var myUser: [User]? {didSet {}}
    
    var arrCountries = [countries]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.callBeHeardAPI()
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectCompanyAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btnSelectCompanySize
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        let arrCompanySize = ["1-10", "11-30", "30-60", "61-100", "101-200", "201-500", "500-1000", "1000+"]
        for companySize in arrCompanySize{
            
            dropDown.dataSource.append(companySize)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtCompanySize.text = item
            
        }
        
        dropDown.direction = .any
        dropDown.show()
    }
    
    @IBAction func btnSelectCountryAction(_ sender: UIButton) {
        
        let dropDown = DropDown()

        dropDown.anchorView = self.btnSelectCountry
        dropDown.semanticContentAttribute = .unspecified
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        for country in arrCountries{
            let name = country.ct_name!
            dropDown.dataSource.append(name)
        }
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            
            self.txtCountry.text = item
            
        }
        
        dropDown.direction = .any
        dropDown.show()
    }
    
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        
        if AppUtility.shared.isEmpty(self.txtFirstName.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "First name is required", delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtLastName.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Last name is required", delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_email", comment: ""), delegate: self)
            return
        }
        if !AppUtility.shared.IsValidEmail(self.txtEmail.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_valid_email", comment: ""), delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtCompanyName.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("Company name is required", comment: ""), delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtCompanySize.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("Company size is required", comment: ""), delegate: self)
            return
        }
        if AppUtility.shared.isEmpty(self.txtCountry.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("Select your country", comment: ""), delegate: self)
            return
        }
        
        self.callContactAPI()
    }
    
    
    //MARK: API Methods
    func callBeHeardAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
                
        APIHandler.sharedInstance.beHeard{ (isSuccess, response) in

            if isSuccess == true{

                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        let countrie = data["countries"] as! [[String : Any]]
                        self.arrCountries = (countrie).map({countries.map(JSONObject: $0, context: nil)})
                        
                    }
                }
                else{
                    
                    let message = response!["message"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
                }
            }
            else{

                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    func callContactAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        let param = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "email": self.txtEmail.text!, "company": self.txtCompanyName.text!, "company_size": self.txtCompanySize.text!, "country": self.txtCountry.text!, "api_token": api_token]
        
        APIHandler.sharedInstance.contact(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: msg, delegate: self)
                }
                else{
                    
                    let message = response!["message"] as! String
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

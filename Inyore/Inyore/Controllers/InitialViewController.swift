//
//  InitialViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {
    
    //MARK: Outlets
    var myUser: [User]? {didSet {}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        DispatchQueue.main.async {
            
            self.myUser = User.readUserFromArchive()
            if (self.myUser != nil && self.myUser?.count != 0){
                
                if self.myUser![0].usr_status == "1"{
                    
                    let data = UserDefaults.standard.value(forKey: "userAgreeTerms")
                    if data != nil{
                        
                        let story = UIStoryboard(name: "Main", bundle: nil)
                        let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
                        tabbarVC.modalPresentationStyle = .fullScreen
                        self.present(tabbarVC, animated: true, completion: nil)
                        return
                    }
                    else{
                        
                        let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "termsVC") as! TermsViewController
                        self.navigationController?.pushViewController(termsVC, animated: true)
                        return
                    }
                    
//                    let story = UIStoryboard(name: "Main", bundle: nil)
//                    let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
//                    tabbarVC.modalPresentationStyle = .fullScreen
//                    self.present(tabbarVC, animated: true, completion: nil)
//                    return
                    
                }
                if self.myUser![0].usr_status == "0"{
                    
                    let userDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "userDetailVC")
                    as! UserDetailViewController
                    self.navigationController?.pushViewController(userDetailVC, animated: true)
                    return
                    
                }
                
            }
            else{
                
                let story = UIStoryboard(name: "Main", bundle: nil)
                let loginVC =  story.instantiateViewController(withIdentifier: "loginVC") as! LoginViewController
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
}

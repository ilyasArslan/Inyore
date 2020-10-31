//
//  CreateTruthScreenViewController.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class CreateTruthScreenViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK: Outlets
    
    @IBOutlet weak var communityCV: UICollectionView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var myUser: [User]? {didSet {}}
    
    var isPicked = Bool()
    var article_title = ""
    var article_description = ""
    var community_banner_image = UIImage()
    
    var arrCommunities = [Communities]()
    var isPin = false
    
    var arrCommunity_ids = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()

    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.callCommunitiesAPI()
    }
    
    //MARK:- Utility Methods
    
    //MARK: API Methods
    func callCommunitiesAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.createTruthCommunities { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        self.lblMessage.isHidden = true
                        let communities = data["communities"] as! [[String : Any]]
                        for community in communities{
                            
                            //self.arrCom.append(community)
                            
                            let cy_is_private = community["cy_is_private"] as! Int
                            let already_joined = community["already_joined"] as! Int
                            
                            if cy_is_private == 0{
                                
                                self.arrCommunities = (communities).map({Communities.map(JSONObject: $0, context: nil)})
                                self.communityCV.reloadData()
                            }
                            else{
                                
                                if already_joined == 1{
                                    
                                    self.arrCommunities = (communities).map({Communities.map(JSONObject: $0, context: nil)})
                                    self.communityCV.reloadData()
                                }
                            }
                            
                        }
                        
                    }
                    else{
                        
                        self.lblMessage.isHidden = false
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
    
    func callCreateTruthAPIWithImage(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let stringRepresentation = self.arrCommunity_ids.description
        
        let params = ["api_token": api_token, "article_title": self.article_title, "article_description": self.article_description, "community_ids": stringRepresentation]
        
        APIHandler.sharedInstance.createTruthWithImage(image: self.community_banner_image, param: params) { (isSuccess, response) in
            
            if isSuccess == true{

                if response!["code"] as! Int == 200{
                    
                    let msg = response!["msg"] as! String
                    
                    let alert = UIAlertController(title: NSLocalizedString("alert_app_name", comment: ""), message: msg, preferredStyle: .alert)
                    alert.view.tintColor = #colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in

                        if let tab = self.tabBarController  {
                             tab.selectedIndex = 1
                             if let home = tab.selectedViewController as? UINavigationController {
                                                home.popToRootViewController(animated: true)
                             }

                        }


                    }))

                    self.present(alert, animated: true, completion: nil)
                    
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
    
    func callCreateTruthAPIWithOutImage(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let stringRepresentation = self.arrCommunity_ids.description
        let params = ["api_token": api_token, "article_title": self.article_title, "article_description": self.article_description, "community_ids": stringRepresentation]
        
        APIHandler.sharedInstance.createTruthWithOutImage(param: params) { (isSuccess, response) in

            if isSuccess == true{

                if response!["code"] as! Int == 200{
                    
                    let msg = response!["msg"] as! String
                    
                    let alert = UIAlertController(title: NSLocalizedString("alert_app_name", comment: ""), message: msg, preferredStyle: .alert)
                    alert.view.tintColor = #colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in

                        if let tab = self.tabBarController  {
                             tab.selectedIndex = 1
                             if let home = tab.selectedViewController as? UINavigationController {
                                                home.popToRootViewController(animated: true)
                             }

                        }
                        
                    }))

                    self.present(alert, animated: true, completion: nil)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrCommunities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let community = self.arrCommunities[indexPath.item]
        let id = community.id!
        
        if self.arrCommunity_ids.contains(id){
            
            let imageUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            print("ImageUrl: ", imageUrl)
            
            let cellCommunity = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCommunity", for: indexPath) as! CommunityCollectionViewCell
            
            cellCommunity.imgCommunity.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo_icon"))
            cellCommunity.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellCommunity.lblCommunityDesc.text = community.cy_description
            
            cellCommunity.btnPin.tag = indexPath.item
            cellCommunity.btnPin.addTarget(self, action: #selector(self.pin(btn:)), for: .touchUpInside)
            
            cellCommunity.btnPin.setTitle("Pinned", for: .normal)
            cellCommunity.btnPin.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
            cellCommunity.btnPin.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.5882352941, blue: 0.2941176471, alpha: 1)
            
            return cellCommunity
            
        }
        else{
            
            let imageUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            print("ImageUrl: ", imageUrl)

            let cellCommunity = collectionView.dequeueReusableCell(withReuseIdentifier: "cellCommunity", for: indexPath) as! CommunityCollectionViewCell
            
            cellCommunity.imgCommunity.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "logo_icon"))
            cellCommunity.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellCommunity.lblCommunityDesc.text = community.cy_description
            
            cellCommunity.btnPin.tag = indexPath.item
            cellCommunity.btnPin.addTarget(self, action: #selector(self.pin(btn:)), for: .touchUpInside)
            
            cellCommunity.btnPin.setTitle("Pin", for: .normal)
            cellCommunity.btnPin.setTitleColor(#colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1), for: .normal)
            cellCommunity.btnPin.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            
            return cellCommunity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
        feedDetailVC.truthId = self.arrCommunities[indexPath.row].id!
        navigationController?.pushViewController(feedDetailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.communityCV.frame.width / 1)
        return CGSize(width: width, height: 260)
    }
    
    //MARK:- btn pin Action
    @objc func pin(btn: UIButton){
        
        let id = self.arrCommunities[btn.tag].id!
        
        if self.arrCommunity_ids.contains(id){
        
            let id = self.arrCommunities[btn.tag].id!
            self.arrCommunity_ids = self.arrCommunity_ids.filter{ $0 != id}
            print("Community Id: ", self.arrCommunity_ids)
            
            btn.setTitle("Pin", for: .normal)
            btn.setTitleColor(#colorLiteral(red: 0.9568627451, green: 0.4549019608, blue: 0.1254901961, alpha: 1), for: .normal)
            btn.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        else {
            
            if self.arrCommunity_ids.count != 3{
                
                let id = self.arrCommunities[btn.tag].id!
                self.arrCommunity_ids.append(id)
                print("Community Id: ", self.arrCommunity_ids)
                                
                btn.setTitle("Pinned", for: .normal)
                btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                btn.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.5882352941, blue: 0.2941176471, alpha: 1)
            }
            
            else{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Maximum pin 3", delegate: self)
            }
            
        }
        
    }
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCreateTruthAction(_ sender: UIButton) {
        
        if self.arrCommunity_ids.count == 0{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Must Pin to atleast 1", delegate: self)
            return
        }
        
        if self.isPicked == true{
            
            self.callCreateTruthAPIWithImage()
            return
        }
        
        if self.isPicked == false{
            
            self.callCreateTruthAPIWithOutImage()
        }
    }
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

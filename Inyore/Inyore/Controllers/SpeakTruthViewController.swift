//
//  SpeakTruthViewController.swift
//  Inyore
//
//  Created by Arslan on 01/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class SpeakTruthViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblTruth: UITableView!
    
    var arrTruth = [SpeakYourTruth]()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
                
        self.tabBarController?.tabBar.isHidden = true
        
        self.tblTruth.tableFooterView = UIView()
        
        self.callSpeakTruthAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblTruth.refreshControl = refreshControl
    }
    //MARK:- Utility Methods
    @objc func refresh(){
        
        refreshControl.endRefreshing()
        callSpeakTruthAPI()
    }
    
    //MARK:- Button Action
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
    
    //MARK: API Methods
    func callSpeakTruthAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.speakTruth { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        self.lblMessage.isHidden = true

                        let my_communities = data["my_communities"] as! [[String : Any]]
                        self.arrTruth = (my_communities).map({SpeakYourTruth.map(JSONObject: $0, context: nil)})
                        self.tblTruth.reloadData()
                        
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
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.arrTruth.count == 0{
            
            self.lblMessage.isHidden = false
            return 0
        }
        else{
            
            self.lblMessage.isHidden = true
            return self.arrTruth.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let truth = self.arrTruth[indexPath.row]
        let imageUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(truth.cy_image_link ?? "")"
        
        let cellSpeakTruth = tableView.dequeueReusableCell(withIdentifier: "cellSpeakTruth") as! SpeakTruthTableViewCell
        
        cellSpeakTruth.imgCommunity.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "speak_your_truth"))
        cellSpeakTruth.lblCommunityTitle.text = "@\(truth.cy_title ?? "")"
        cellSpeakTruth.lblCommunityMember.text = "\(truth.members ?? 0) member"
        cellSpeakTruth.lblCommunityDesc.text = truth.cy_description
        
        return cellSpeakTruth
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
        singleCommunityVC.community_id = self.arrTruth[indexPath.row].id!
        navigationController?.pushViewController(singleCommunityVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

//
//  NotificationViewController.swift
//  Inyore
//
//  Created by Arslan on 03/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class NotificationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    //MARK: Outlets
    
    @IBOutlet weak var tblNotification: UITableView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var notiTitle = ""
    var notiMessage = ""
    
    var refreshControl = UIRefreshControl()
    
    var arrNotifications = [Notifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.items?.first?.badgeValue = nil
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblNotification.refreshControl = refreshControl
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tblNotification.tableFooterView = UIView()
        
        self.callNotificationAPI()
    }
    
    //MARK:- Utility Methods
    @objc func refresh(){
        
        refreshControl.endRefreshing()
        self.callNotificationAPI()
    }
    
    //MARK:- Button Action
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
    
    //MARK: API Methods
    func callNotificationAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.notification { (isSuccess, response) in
            
            if isSuccess == true{
             
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        self.lblMessage.isHidden = true
                        
                        let notifications = data["notifications"] as! [[String : Any]]
                        self.arrNotifications = (notifications).map({Notifications.map(JSONObject: $0, context: nil)})
                        self.tblNotification.reloadData()
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
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let notify = self.arrNotifications[indexPath.row]
        
        if notify.nt_article_id != 0{

            self.notiTitle = notify.ar_title ?? ""
            self.notiMessage = "New post created by \(notify.rd_username ?? "")"
        }
        else if notify.nt_community_id != 0{

            self.notiTitle = notify.cy_title ?? ""
            self.notiMessage = "New community created by \(notify.rd_username ?? "")"
        }
        else if notify.nt_comment_id != 0{

            self.notiTitle = notify.ct_message ?? ""
            self.notiMessage = "New comment posted by \(notify.rd_username ?? "")"
        }
        
        let cellNotification = tableView.dequeueReusableCell(withIdentifier: "cellNotification") as! NotificationTableViewCell
        
        cellNotification.lblNotificationTitle.text = self.notiTitle
        cellNotification.lblNotificationMessage.text = self.notiMessage
        
        let dateAsString = notify.created_at!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        let date = formatter.date(from: dateAsString)!
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: date)
        cellNotification.lblNotificationTime.text = "at \(time) pst"
        
        if notify.is_viewed == 1{
            
            cellNotification.isReadView.isHidden = true
        }
        else{
            
            cellNotification.isReadView.isHidden = false
        }
        
        return cellNotification
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notify = self.arrNotifications[indexPath.row]
        
        if notify.nt_article_id != 0{

            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = notify.nt_article_id!
            feedDetailVC.truthTitle = notify.ar_title ?? ""
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        else if notify.nt_community_id != 0{

            let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
            singleCommunityVC.community_id = notify.nt_community_id!
            singleCommunityVC.communityTitle = notify.cy_title ?? ""
            navigationController?.pushViewController(singleCommunityVC, animated: true)
        }
        else if notify.nt_comment_id != 0{

            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = notify.comment_article_id!
            feedDetailVC.truthTitle = notify.comment_article_title ?? ""
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

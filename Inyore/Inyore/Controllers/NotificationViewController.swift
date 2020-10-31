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
    
    var arrNotifications = [Notifications]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tblNotification.tableFooterView = UIView()
        
        self.callNotificationAPI()
        
    }
    
    //MARK:- Utility Methods
    
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
        
        let cellNotification = tableView.dequeueReusableCell(withIdentifier: "cellNotification") as! NotificationTableViewCell
        cellNotification.lblNotificationTitle.text = notify.rd_username
        cellNotification.lblNotificationMessage.text = notify.ct_message
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

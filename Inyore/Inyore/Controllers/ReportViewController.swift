//
//  ReportViewController.swift
//  Inyore
//
//  Created by Arslan on 31/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import Starscream

class ReportViewController: UIViewController, WebSocketDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var btnIrrelevant: UIButton!
    @IBOutlet weak var btnBulying: UIButton!
    @IBOutlet weak var btnHarassment: UIButton!
    @IBOutlet weak var btnTrolling: UIButton!
    @IBOutlet weak var btnInappropriate: UIButton!
    @IBOutlet weak var btnDiscrimination: UIButton!
    @IBOutlet weak var btnInvasion: UIButton!
    @IBOutlet weak var btnImpersonation: UIButton!
    @IBOutlet weak var btnPrivateCompany: UIButton!
    @IBOutlet weak var btnSpam: UIButton!
    @IBOutlet weak var btnOther: UIButton!
        
    var myUser: [User]? {didSet {}}
    var uid = Int()
    var remember_token = String()
    
    var sec = Int()
    var comment = [String : Any]()
    var truthId = Int()
    
    var url: URL!
    var request: URLRequest!
    var websocket: WebSocket!
    
    var rep_type = ""
    var repost_tid = ""
    
    var arrReport = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
                
        self.myUser = User.readUserFromArchive()
        self.uid = self.myUser![0].id!
        self.remember_token = self.myUser![0].remember_token!
        
        self.url = URL(string: "wss://inyore.com:5678?articleid=\(self.truthId)&uid=\(self.uid)&remebertoken=\(self.remember_token)")
        print("Url: ", url!)
        self.request = URLRequest(url: url)
        self.websocket = WebSocket(request: request)
        websocket.delegate = self
        websocket.connect()
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        if self.rep_type == "post"{
            
            navigationController?.popViewController(animated: true)
        }
        else{
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCollectionAction(_ sender: UIButton) {
        
        if sender.tag == 0{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(1)"
        }
        else if sender.tag == 1{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(2)"
        }
        else if sender.tag == 2{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(3)"
        }
        else if sender.tag == 3{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(4)"
        }
        else if sender.tag == 4{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(5)"
        }
        else if sender.tag == 5{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(6)"
        }
        else if sender.tag == 6{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(7)"
        }
        else if sender.tag == 7{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(8)"
        }
        else if sender.tag == 8{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(9)"
        }
        else if sender.tag == 9{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            
            self.repost_tid = "\(10)"
        }
        else{
            
            self.btnIrrelevant.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnBulying.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnHarassment.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnTrolling.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInappropriate.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnDiscrimination.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnInvasion.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnImpersonation.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnPrivateCompany.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnSpam.setImage(#imageLiteral(resourceName: "checkedUnfill"), for: .normal)
            self.btnOther.setImage(#imageLiteral(resourceName: "checked"), for: .normal)
            
            self.repost_tid = "\(11)"
        }
    }
    
    @IBAction func btnReportAction(_ sender: Any) {
        
        if rep_type == "post"{
            
            if self.repost_tid == ""{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please choose the report cause", delegate: self)
            }
            else{
                
                let jsonData = ["msgtype": "mr", "rep_type": "0", "rept_id": self.truthId, "repost_tid": self.repost_tid, "userid": self.uid, "articleid": self.truthId] as [String : Any]
                let messageString = AppUtility.shared.jsonToString(json: jsonData)
                websocket.write(string: messageString)
            }
        }
        else{
            
            if self.repost_tid == ""{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please choose the report cause", delegate: self)
            }
            else{
                
                let id = self.comment["id"] as! Int
                let jsonData = ["msgtype": "mr", "rep_type": "1", "rept_id": id, "repost_tid": self.repost_tid, "userid": self.uid, "articleid": self.truthId] as [String : Any]
                let messageString = AppUtility.shared.jsonToString(json: jsonData)
                websocket.write(string: messageString)
            }
        }
    }
    
    //MARK:- DELEGATE METHODS
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Disconnected")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let json = AppUtility.shared.stringToJson(str: text)
        print("Json: ", json)
        let jsonType = json["type"] as! String
        let checkType = jsonType
        
        switch checkType {
            
        case "mr":
            
            if json["rt"] as! String == "0"{
                
                NotificationCenter.default.post(name: Notification.Name("callHomeAPI"), object: nil, userInfo: nil)
                navigationController?.popToViewController(ofClass: HomeViewController.self)
            }
                
            else if json["rt"] as! String == "1"{
                
                NotificationCenter.default.post(name: Notification.Name("sendSection"), object: nil, userInfo: ["section": self.sec])
                dismiss(animated: true, completion: nil)
            }
            
        default:
            break
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Receive data")
    }
    
    //MARK: API Methods
    func callReportAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.getReport{ (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        let reports = data["reports"] as! NSArray
                        
                        for i in 0..<reports.count{
                            
                            let report = reports[i] as! [String : Any]
                            self.arrReport.append(report)
                        }
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
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
}

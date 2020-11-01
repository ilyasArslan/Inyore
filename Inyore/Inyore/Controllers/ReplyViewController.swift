//
//  ReplyViewController.swift
//  Inyore
//
//  Created by Arslan on 01/11/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import Starscream

class ReplyViewController: UIViewController, WebSocketDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var txtReply: CustomTextView!
    
    var myUser: [User]? {didSet {}}
    var uid = Int()
    var remember_token = String()
    
    var comment = [String : Any]()
    var truthId = Int()
    
    var url: URL!
    var request: URLRequest!
    var websocket: WebSocket!
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
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSendAction(_ sender: UIButton) {
        
        let id = comment["id"] as? Int ?? comment["cid"] as! Int
        let jsonData = ["msgtype": "rpct", "message": self.txtReply.text!, "userid": self.uid, "articleid": self.truthId, "pcid": id] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        self.websocket.write(string: messageString)
        
        NotificationCenter.default.post(name: Notification.Name("reloadData"), object: nil, userInfo: nil)
    }
    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    func websocketDidConnect(socket: WebSocketClient) {
        print("Connected")
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print("Disconnect")
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        let json = AppUtility.shared.stringToJson(str: text)
        print("Json: ", json)
        let jsonType = json["type"] as! String
        let checkType = jsonType
        
        switch checkType {
        case "urc":
            navigationController?.popViewController(animated: true)
        default:
            break
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Receive Data")
    }
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    
}

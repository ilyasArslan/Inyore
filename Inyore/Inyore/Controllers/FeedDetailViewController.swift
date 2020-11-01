//
//  FeedDetailViewController.swift
//  Inyore
//
//  Created by Arslan on 23/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import Starscream
import IQKeyboardManagerSwift

class FeedDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, WebSocketDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var scrlView: UIScrollView!
    
    @IBOutlet weak var lblSingleTruthTitle: UILabel!
    @IBOutlet weak var lblSingleTruthTime: UILabel!
    @IBOutlet weak var lblSingleTruthDesc: UILabel!
    
    @IBOutlet weak var btnViews: CustomButton!
    @IBOutlet weak var btnComment: CustomButton!
    @IBOutlet weak var btnPraise: CustomButton!
    @IBOutlet weak var btnShare: CustomButton!
    @IBOutlet weak var btnReport: CustomButton!
    
    @IBOutlet weak var lblConnecting: UILabel!
    @IBOutlet weak var txtComment: CustomTextView!
    
    @IBOutlet weak var btnSend: CustomButton!
    @IBOutlet weak var btnCancel: CustomButton!
    
    @IBOutlet weak var lblCommentCounts: UILabel!
    
    @IBOutlet weak var tblComments: UITableView!
    @IBOutlet weak var tblCommentHeight: NSLayoutConstraint!
    
    var myUser: [User]? {didSet {}}
    var uid = Int()
    var remember_token = String()
    
    var truthId = Int()
    var arrComments = [[String : Any]]()
    
    var url: URL!
    var request: URLRequest!
    var websocket: WebSocket!
    
    var sec = Int()
    var index = IndexPath()
    var cellSection = Int()
    var viewType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        print("Truth ID: ", truthId)
        self.callSingleTruthAPI()
        
        self.myUser = User.readUserFromArchive()
        self.uid = self.myUser![0].id!
        self.remember_token = self.myUser![0].remember_token!
        self.lblConnecting.text = "Commenting as \(self.myUser![0].full_username ?? "User")"
        
        self.url = URL(string: "wss://inyore.com:5678?articleid=\(self.truthId)&uid=\(self.uid)&remebertoken=\(self.remember_token)")
        self.request = URLRequest(url: url)
        self.websocket = WebSocket(request: request)
        websocket.delegate = self
        websocket.connect()
        
        self.tblComments.register(HeaderView.nib, forHeaderFooterViewReuseIdentifier: HeaderView.reuseIdentifier)
        
        self.tabBarController?.tabBar.isHidden = true
        self.btnCancel.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("sendSection"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callReloadData(notification:)), name: Notification.Name("reloadData"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        IQKeyboardManager.shared.disabledToolbarClasses.append(FeedDetailViewController.self)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(FeedDetailViewController.self)
        
        self.tblComments.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        tblComments.sectionHeaderHeight = UITableView.automaticDimension

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tblComments.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if(keyPath == "contentSize"){
            
            self.tblCommentHeight.constant = self.tblComments.contentSize.height
        }
        
    }
    
    //MARK:- Utility Methods
    @objc func methodOfReceivedNotification(notification: Notification) {

        let receiveSection = notification.userInfo!["section"] as! Int
        print("Receive Section: ", receiveSection)
        self.arrComments.remove(at: receiveSection)
        self.tblComments.reloadData()
        
        self.countComments()
    }
    
    @objc func callReloadData(notification: Notification){
        
        self.callSingleTruthAPI()
        self.tblComments.reloadData()
    }
    
    func countComments(){
        
        var totalReplyCount = 0
        for i in 0..<arrComments.count{
            
            let reply = tblComments.numberOfRows(inSection: i)
            totalReplyCount = totalReplyCount + reply
        }
        let totalCount = totalReplyCount + self.arrComments.count
        self.lblCommentCounts.text = "\(totalCount) Comments"
    }
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnCollectionAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            
            self.txtComment.becomeFirstResponder()
        }
        else if sender.tag == 3{
            
            let text = "https://www.inyore.com/article/\(self.truthId)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else if sender.tag == 4{
            
            let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
            reportVC.modalPresentationStyle = .fullScreen
            
            reportVC.rep_type = "post"
            reportVC.truthId = self.truthId
            
            navigationController?.pushViewController(reportVC, animated: true)
        }
    }
    
    @IBAction func btnSendCommentAction(_ sender: UIButton) {
        
        let isEmpty = self.txtComment.text.trimmingCharacters(in: .whitespaces).isEmpty
        if isEmpty == true{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: "Please type message to send", delegate: self)
        }
        else{
            
            if self.viewType == "headerComment"{
                
                let main_comment = self.arrComments[self.sec]["main_comment"] as! [String : Any]
                let id = main_comment["id"] as? Int ?? main_comment["cid"] as! Int
                let jsonData = ["msgtype": "edct", "message": "\(self.txtComment.text!)", "userid": self.uid, "articleid": self.truthId, "ctid": id, "cttype": "main"] as [String : Any]
                let messageString = AppUtility.shared.jsonToString(json: jsonData)
                websocket.write(string: messageString)
            }
            else if viewType == "cellReply"{
                
            }
            
            else{
                
                let jsonData = ["msgtype": "mct", "message": "\(self.txtComment.text!)", "userid": self.uid, "articleid": self.truthId] as [String : Any]
                let messageString = AppUtility.shared.jsonToString(json: jsonData)
                websocket.write(string: messageString)

                self.txtComment.text = ""
                self.txtComment.resignFirstResponder()
            }
            
        }
    }
    
    @IBAction func btnCancelAction(_ sender: UIButton) {
        
        self.viewType = ""
        self.btnCancel.isHidden = true
        self.btnSend.setTitle("Send", for: .normal)
        
        self.txtComment.text = ""
        self.txtComment.resignFirstResponder()
    }
    
    //MARK:- TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if self.arrComments.count == 0{
            
            self.tblComments.isHidden = true
            return 0
        }
        else{
            
            self.tblComments.isHidden = false
            return self.arrComments.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let headerComment = tblComments.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.reuseIdentifier) as? HeaderView else{ return nil}
        
        let main_comment = self.arrComments[section]["main_comment"] as! [String : Any]
        let userId = main_comment["ct_user_id"] as? Int ?? main_comment["uid"] as! Int

        if userId == self.uid{

            headerComment.lblName.text = "Me"
            headerComment.btnMoreMenu.isHidden = false
            headerComment.btnReport.isHidden = true
        }
        else{

            headerComment.lblName.text = main_comment["ct_username"] as? String
            headerComment.btnMoreMenu.isHidden = true
            headerComment.btnReport.isHidden = false
        }

        if let dateAsString = main_comment["created_at"] as? String{

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
            let date = formatter.date(from: dateAsString)!
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            headerComment.lblTime.text = time
        }
        else{

            let time = main_comment["ct"] as! String
            headerComment.lblTime.text = time
        }

        if let ct_message = main_comment["ct_message"] as? String{

            headerComment.lblComment.text = ct_message
        }
        else{

            let cmt = main_comment["cmt"] as? String
            headerComment.lblComment.text = cmt
        }


        let total_praises = main_comment["total_praises"] as? Int ?? 0
        let total_hearts = main_comment["total_hearts"] as? Int ?? 0
        let total_disappoints = main_comment["total_disappoints"] as? Int ?? 0


        if total_praises == 0 && total_hearts == 0 && total_disappoints == 0{

            headerComment.lblCommentBottom.constant = 20
        }
        else{

            headerComment.lblCommentBottom.constant = 70
        }

        if total_praises == 0{

            headerComment.btnPraise.isHidden = true
        }
        else{

            headerComment.btnPraise.isHidden = false
        }
        if total_hearts == 0{

            headerComment.btnLike.isHidden = true
        }
        else{

            headerComment.btnLike.isHidden = false
        }
        if total_disappoints == 0{

            headerComment.btnDisappoint.isHidden = true
        }
        else{

            headerComment.btnDisappoint.isHidden = false
        }


        headerComment.btnPraise.setTitle("\(total_praises)", for: .normal)
        headerComment.btnLike.setTitle("\(total_hearts)", for: .normal)
        headerComment.btnDisappoint.setTitle("\(total_disappoints)", for: .normal)

        headerComment.btnDidPraise.tag = section
        headerComment.btnDidPraise.addTarget(self, action: #selector(self.didCommentPraiseAction(_:)), for: .touchUpInside)
        
        headerComment.btnDidHeart.tag = section
        headerComment.btnDidHeart.addTarget(self, action: #selector(self.didCommentHeartAction(_:)), for: .touchUpInside)
        
        headerComment.btnDidDisappoint.tag = section
        headerComment.btnDidDisappoint.addTarget(self, action: #selector(self.didCommentDisappointAction(_:)), for: .touchUpInside)

        headerComment.btnReply.tag = section
        headerComment.btnReply.addTarget(self, action: #selector(self.CommentReplyAction(_:)), for: .touchUpInside)
        
        headerComment.btnReport.tag = section
        headerComment.btnReport.addTarget(self, action: #selector(self.CommentReportAction(_:)), for: .touchUpInside)
        
        headerComment.btnMoreMenu.tag = section
        headerComment.btnMoreMenu.addTarget(self, action: #selector(self.moreMoreMenuCommentAction(_:)), for: .touchUpInside)

        return headerComment
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        let separatorView = UIView(frame: CGRect(x: tableView.separatorInset.left, y: 0, width: tableView.frame.width, height: 1))
        separatorView.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        footerView.addSubview(separatorView)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let replies = self.arrComments[section]["replies"] as! [[String : Any]]
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReply = tableView.dequeueReusableCell(withIdentifier: "cellReply") as! ReplyTableViewCell
        
        let replies = self.arrComments[indexPath.section]["replies"] as! [[String : Any]]
        
        let userId = replies[indexPath.row]["ct_user_id"] as? Int ?? replies[indexPath.row]["uid"] as! Int

        if userId == self.uid{

            cellReply.lblName.text = "Me"
            cellReply.btnMore.isHidden = false
            cellReply.btnReport.isHidden = true
        }
        else{

            cellReply.lblName.text = replies[indexPath.row]["ct_username"] as? String
            cellReply.btnMore.isHidden = true
            cellReply.btnReport.isHidden = false
        }
        
        let dateAsString = replies[indexPath.row]["created_at"] as! String
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(abbreviation: "PST")
        let date = formatter.date(from: dateAsString)!
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: date)
        cellReply.lblTime.text = time
        
        cellReply.lblReply.text = replies[indexPath.row]["ct_message"] as? String
        
        let total_praises = replies[indexPath.row]["total_praises"] as! Int
        let total_hearts = replies[indexPath.row]["total_hearts"] as! Int
        let total_disappoints = replies[indexPath.row]["total_disappoints"] as! Int
        
        if total_praises == 0 && total_hearts == 0 && total_disappoints == 0{
            
            cellReply.lblReplyBottom.constant = 20
        }
        else{
            
            cellReply.lblReplyBottom.constant = 70
        }
        
        if total_praises == 0{
            
            cellReply.btnPraise.isHidden = true
        }
        else{
            
            cellReply.btnPraise.isHidden = false
        }
        if total_hearts == 0{
            
            cellReply.btnLike.isHidden = true
        }
        else{
            
            cellReply.btnLike.isHidden = false
        }
        if total_disappoints == 0{
            
            cellReply.btnDisAppoint.isHidden = true
        }
        else{
            
            cellReply.btnDisAppoint.isHidden = false
        }
        
        cellReply.btnPraise.setTitle("\(total_praises)", for: .normal)
        cellReply.btnLike.setTitle("\(total_hearts)", for: .normal)
        cellReply.btnDisAppoint.setTitle("\(total_disappoints)", for: .normal)
        
        cellReply.btnDidPraise.addTarget(self, action: #selector(self.didReplyPraiseAction(_:)), for: .touchUpInside)
        cellReply.btnDidHeart.addTarget(self, action: #selector(self.didReplyHeartAction(_:)), for: .touchUpInside)
        cellReply.btnDidDisappoint.addTarget(self, action: #selector(self.didReplyDisappointAction(_:)), for: .touchUpInside)
        cellReply.btnReply.addTarget(self, action: #selector(self.ReplyAction(_:)), for: .touchUpInside)
        cellReply.btnMore.addTarget(self, action: #selector(self.moreMenuReplyAction(_:)), for: .touchUpInside)
        
        return cellReply
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    //MARK:- Comment buttons Action
    @objc func didCommentPraiseAction(_ btn: UIButton) {
        
        self.sec = btn.tag
        self.viewType = "headerComment"
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        let id = main_comment["id"] as? Int ?? main_comment["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "1", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func didCommentHeartAction(_ btn: UIButton) {
        
        self.sec = btn.tag
        self.viewType = "headerComment"
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        let id = main_comment["id"] as? Int ?? main_comment["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "2", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func didCommentDisappointAction(_ btn: UIButton) {
        
        self.sec = btn.tag
        self.viewType = "headerComment"
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        let id = main_comment["id"] as? Int ?? main_comment["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "3", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func CommentReplyAction(_ btn: UIButton){
        
        self.sec = btn.tag
        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "replyVC") as! ReplyViewController
        replyVC.truthId = self.truthId
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        replyVC.comment = main_comment
        
        navigationController?.pushViewController(replyVC, animated: true)
    }
    
    @objc func CommentReportAction(_ btn: UIButton){
        
        let reportVC = self.storyboard?.instantiateViewController(withIdentifier: "reportVC") as! ReportViewController
        reportVC.modalPresentationStyle = .fullScreen
        
        self.sec = btn.tag
        
        reportVC.sec = btn.tag
        reportVC.rep_type = "comment"
        reportVC.truthId = self.truthId
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        reportVC.comment = main_comment
        
        present(reportVC, animated: true, completion: nil)
    }
    
    @objc func moreMoreMenuCommentAction(_ btn: UIButton){
                
        
        let actionSheet = UIAlertController.init(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (actionSheetAlert) in
            
            self.sec = btn.tag
            self.viewType = "headerComment"
            self.btnCancel.isHidden = false
            self.btnSend.setTitle("Update", for: .normal)
            self.txtComment.becomeFirstResponder()
            
            let headerComment = self.tblComments.headerView(forSection: self.sec) as! HeaderView
            self.txtComment.text = headerComment.lblComment.text
            
            self.scrlView.scrollToTop(animated: true)
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (actionSheetAlert) in
            
            let alert = UIAlertController.init(title: "Are you sure?", message: "Do you really want to delete this record? This will not be undo.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (alertAction) in
                
            }))
            
            alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (alertAction) in
                
                self.sec = btn.tag
                self.viewType = "headerComment"
                
                let main_comment = self.arrComments[self.sec]["main_comment"] as! [String : Any]
                let id = main_comment["id"] as? Int ?? main_comment["cid"] as! Int
                let jsonData = ["msgtype": "delcmt", "userid": self.uid, "articleid": self.truthId, "ctid": id] as [String : Any]
                let messageString = AppUtility.shared.jsonToString(json: jsonData)
                self.websocket.write(string: messageString)
            }))
            
            self.present(alert, animated: true, completion: nil)
            

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (actionSheetAlert) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK:- Reply buttons Action
    @objc func didReplyPraiseAction(_ btn: UIButton) {
        
        let cell = getCellForView(view: btn)
        let indexPath = tblComments.indexPath(for: cell!)
        self.index = indexPath!
        self.viewType = "cellReply"
        
        let replies = self.arrComments[indexPath!.section]["replies"] as! [[String : Any]]
        let reply = replies[indexPath!.row]
        let id = reply["id"] as? Int ?? reply["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "1", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func didReplyHeartAction(_ btn: UIButton) {
        
        let cell = getCellForView(view: btn)
        let indexPath = tblComments.indexPath(for: cell!)
        self.index = indexPath!
        self.viewType = "cellReply"
        
        let replies = self.arrComments[indexPath!.section]["replies"] as! [[String : Any]]
        let reply = replies[indexPath!.row]
        let id = reply["id"] as? Int ?? reply["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "2", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func didReplyDisappointAction(_ btn: UIButton) {
        
        let cell = getCellForView(view: btn)
        let indexPath = tblComments.indexPath(for: cell!)
        self.index = indexPath!
        self.viewType = "cellReply"
        
        let replies = self.arrComments[indexPath!.section]["replies"] as! [[String : Any]]
        let reply = replies[indexPath!.row]
        let id = reply["id"] as? Int ?? reply["cid"] as! Int
        let jsonData = ["msgtype": "sem", "emot": "3", "userid": self.uid, "commentId": id, "articleid": self.truthId] as [String : Any]
        let messageString = AppUtility.shared.jsonToString(json: jsonData)
        websocket.write(string: messageString)
    }
    
    @objc func ReplyAction(_ btn: UIButton){
        
        let cell = getCellForView(view: btn)
        let indexPath = tblComments.indexPath(for: cell!)
        self.index = indexPath!
        self.sec = self.index.section
        let replyVC = self.storyboard?.instantiateViewController(withIdentifier: "replyVC") as! ReplyViewController
        replyVC.truthId = self.truthId
        
        let main_comment = self.arrComments[sec]["main_comment"] as! [String : Any]
        replyVC.comment = main_comment
        
        navigationController?.pushViewController(replyVC, animated: true)
    }
    
    @objc func moreMenuReplyAction(_ btn: UIButton){
                        
        let actionSheet = UIAlertController.init(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (actionSheetAlert) in
            
            print("Edit")
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (actionSheetAlert) in
            
            let alert = UIAlertController.init(title: "Are you sure?", message: "Do you really want to delete this record? This will not be undo.", preferredStyle: .alert)

            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (alertAction) in

            }))

            alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { (alertAction) in

                let cell = self.getCellForView(view: btn)
                let indexPath = self.tblComments.indexPath(for: cell!)
                self.index = indexPath!
                self.viewType = "cellReply"

                print("IndexPath: ", self.index)
                var arr = self.arrComments[self.index.section]["replies"] as! [[String : Any]]
                arr.remove(at: 0)

                DispatchQueue.main.async {

                    self.tblComments.reloadData()
                }


//                let replies = self.arrComments[indexPath!.section]["replies"] as! [[String : Any]]
//                let reply = replies[indexPath!.row]
//                let id = reply["id"] as? Int ?? reply["cid"] as! Int
//                let jsonData = ["msgtype": "delcmt", "userid": self.uid, "articleid": self.truthId, "ctid": id] as [String : Any]
//                let messageString = AppUtility.shared.jsonToString(json: jsonData)
//                self.websocket.write(string: messageString)



            }))

            self.present(alert, animated: true, completion: nil)
            

        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (actionSheetAlert) in
            
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
    //MARK:- get indexPath for unknown row cell
    func getCellForView(view:UIView) -> UITableViewCell?{
        
        var superView = view.superview
        
        while superView != nil
        {
            if superView is UITableViewCell
            {
                return superView as? UITableViewCell
            }
            else
            {
                superView = superView?.superview
            }
        }
        
        return nil
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
            
        case "usct":
            
            let comment = ["main_comment": json, "replies": []] as [String : Any]
            
            self.arrComments.append(comment)
            
            self.tblComments.beginUpdates()
            let indexSet = IndexSet(integer: self.arrComments.count - 1)
            self.tblComments.insertSections(indexSet, with: .none)
            self.tblComments.endUpdates()
            
            DispatchQueue.main.async {
                self.scrlView.scrollToBottom()
            }
            
            self.countComments()
            
        case "sm":
            
            if self.viewType == "headerComment"{
                
                let headerComment = tblComments.headerView(forSection: self.sec) as! HeaderView
                
                if json["pret"] as! Int == 1{
                    
                    let count = Int(headerComment.btnPraise.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        headerComment.btnPraise.isHidden = true
                    }
                    
                    headerComment.btnPraise.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["pret"] as! Int == 2{
                    
                    let count = Int(headerComment.btnLike.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        headerComment.btnLike.isHidden = true
                    }
                    
                    headerComment.btnLike.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["pret"] as! Int == 3{
                    
                    let count = Int(headerComment.btnDisappoint.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        headerComment.btnDisappoint.isHidden = true
                    }
                    
                    headerComment.btnDisappoint.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                    
                }
                
                if json["uem"] as! String == "1"{
                    
                    headerComment.btnPraise.isHidden = false
                    let count = Int(headerComment.btnPraise.currentTitle!)!
                    let incr = count + 1
                    headerComment.btnPraise.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["uem"] as! String == "2"{
                    
                    headerComment.btnLike.isHidden = false
                    let count = Int(headerComment.btnLike.currentTitle!)!
                    let incr = count + 1
                    headerComment.btnLike.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else{
                    
                    headerComment.btnDisappoint.isHidden = false
                    let count = Int(headerComment.btnDisappoint.currentTitle!)!
                    let incr = count + 1
                    headerComment.btnDisappoint.setTitle("\(incr)", for: .normal)
                    headerComment.lblCommentBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
            }
                
            else if viewType == "cellReply"{
                
                let cellReply = tblComments.cellForRow(at: index) as! ReplyTableViewCell
                if json["pret"] as! Int == 1{
                    
                    let count = Int(cellReply.btnPraise.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        cellReply.btnPraise.isHidden = true
                    }
                    
                    cellReply.btnPraise.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["pret"] as! Int == 2{
                    
                    let count = Int(cellReply.btnLike.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        cellReply.btnLike.isHidden = true
                    }
                    
                    cellReply.btnLike.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["pret"] as! Int == 3{
                    
                    let count = Int(cellReply.btnDisAppoint.currentTitle!)!
                    let incr = count - 1
                    
                    if incr == 0{
                        cellReply.btnDisAppoint.isHidden = true
                    }
                    
                    cellReply.btnDisAppoint.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                    
                }
                
                if json["uem"] as! String == "1"{
                    
                    cellReply.btnPraise.isHidden = false
                    let count = Int(cellReply.btnPraise.currentTitle!)!
                    let incr = count + 1
                    cellReply.btnPraise.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else if json["uem"] as! String == "2"{
                    
                    cellReply.btnLike.isHidden = false
                    let count = Int(cellReply.btnLike.currentTitle!)!
                    let incr = count + 1
                    cellReply.btnLike.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
                    
                else{
                    
                    cellReply.btnDisAppoint.isHidden = false
                    let count = Int(cellReply.btnDisAppoint.currentTitle!)!
                    let incr = count + 1
                    cellReply.btnDisAppoint.setTitle("\(incr)", for: .normal)
                    cellReply.lblReplyBottom.constant = 70
                    UIView.performWithoutAnimation {
                        self.tblComments.beginUpdates()
                        self.tblComments.endUpdates()
                        tblComments.tableFooterView = tblComments.tableFooterView
                    }
                }
            }
            
        case "upct":
            
            if viewType == "headerComment"{
                
                self.btnCancel.isHidden = true
                self.viewType = ""
                self.btnSend.setTitle("Send", for: .normal)
                self.txtComment.text = ""
                self.txtComment.resignFirstResponder()
                
                let headerComment = tblComments.headerView(forSection: self.sec) as! HeaderView
                headerComment.lblComment.text = json["cmt"] as? String
                headerComment.lblTime.text = (json["ct"] as! String)
                
                scrlView.scrollToView(view: headerComment, animated: true)
            }
                
            else if self.viewType == "cellReply"{
                
            }
            
        case "delct":
            
            if self.viewType == "headerComment"{
                
                self.arrComments.remove(at: self.sec)
                self.tblComments.reloadData()
                self.viewType = ""
                self.countComments()
            }
                
            else if self.viewType == "cellReply"{
                
                //                arrComments.remove(at: index.row)
                //                tblComments.beginUpdates()
                //                tblComments.deleteRows(at: [index], with: .automatic)
                //                tblComments.endUpdates()
            }
            
        default:
            break
        }
        
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Receive Data")
    }
    
    
    //MARK:- API Methods
    func callSingleTruthAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        AppUtility.shared.showOnSpecificController(viewHud: self.view)
        
        APIHandler.sharedInstance.singleTruth(truthId: "\(self.truthId)") { (isSuccess, response) in
                        
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        AppUtility.shared.hideOnSpecificControllers(viewHud: self.view)
                        
                        let single_article = data["single_article"] as! NSDictionary
                        let all_comments = data["all_comments"] as! [[String : Any]]
                        
                        self.lblSingleTruthTitle.text = single_article["ar_title"] as? String
                        
                        let dateAsString = single_article["updated_at"] as? String ?? ""
                        let formatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        formatter.timeZone = TimeZone(abbreviation: "PST")
                        let date = formatter.date(from: dateAsString)!
                        formatter.dateFormat = "hh:mm a"
                        let time = formatter.string(from: date)
                        
                        let usr_username = single_article["usr_username_id"] as? String ?? ""
                        self.lblSingleTruthTime.text = "posted by \(usr_username) at \(time) pst"
                        
                        self.lblSingleTruthDesc.text = single_article["ar_description"] as? String
                        
                        self.btnViews.setTitle("\(single_article["userviews"] as! Int)", for: .normal)
                        self.btnComment.setTitle("\(single_article["usercomments"] as! Int)", for: .normal)
                        self.btnPraise.setTitle("\(single_article["userpraises"] as! Int)", for: .normal)
                        
//                        let no_of_comments = data["no_of_comments"] as! Int
//                        self.lblCommentCounts.text = "\(no_of_comments) Comments"
                        
                        self.arrComments = all_comments
                        self.tblComments.reloadData()
                        
                        self.countComments()
                        
                    }
                }
                else{
                    
                    AppUtility.shared.hideOnSpecificControllers(viewHud: self.view)
                    let message = response!["message"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
                }
            }
            else{
                
                AppUtility.shared.hideOnSpecificControllers(viewHud: self.view)
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
}

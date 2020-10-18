//
//  FeedDetailViewController.swift
//  Inyore
//
//  Created by Arslan on 23/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class FeedDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    //MARK: Outlets
    @IBOutlet weak var lblCommentCounts: UILabel!
    @IBOutlet weak var tblComments: UITableView!
    
    @IBOutlet weak var tblCommentHeight: NSLayoutConstraint!
        
    var arrComments = [[String : Any]]()
    var arrReplies = [String]()
    
    var truthId = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        let replies1 = [["commentid": "1", "replyMessage": "How are you"]]
        let replies2 = [["commentid": "2", "replyMessage": "Hello"]]
        let replies3 = [["commentid": "3", "replyMessage": "Heloo where"]]
        let replies4 = [["commentid": "4", "replyMessage": "Why"]]
        
        let main_comment1 = ["commentid": "1", "comment": "Iam sad", "replies": replies1] as [String : Any]
        let main_comment2 = ["commentid": "2", "comment": "Iam Happy", "replies": replies2] as [String : Any]
        let main_comment3 = ["commentid": "3", "comment": "Iam Lovely", "replies": replies3] as [String : Any]
        let main_comment4 = ["commentid": "4", "comment": "Iam Angry", "replies": replies4] as [String : Any]
        
        self.arrComments.append(main_comment1)
        self.arrComments.append(main_comment2)
        self.arrComments.append(main_comment3)
        self.arrComments.append(main_comment4)
        
    }
    
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tblCommentHeight.constant = self.tblComments.contentSize.height
    }
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.arrComments.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cellComment = tableView.dequeueReusableCell(withIdentifier: "cellComment") as! CommentTableViewCell
        let comment = self.arrComments[section]["comment"] as? String ?? ""
        cellComment.lblComment.text = comment
        return cellComment
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let replies = self.arrComments[section]["replies"] as! [[String : Any]]
        return replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let arrMain = self.arrComments[indexPath.row]
        let commentId = arrMain["commentid"] as! String
        
        let arrReplies = self.arrComments[indexPath.section]["replies"] as! [[String : Any]]
        let replyId = arrReplies[indexPath.row]["commentid"] as! String
        let reply = arrReplies[indexPath.row]["replyMessage"] as! String
        
        print("ReplY: ", reply)
        
        let cellReply = tableView.dequeueReusableCell(withIdentifier: "cellReply") as! ReplyTableViewCell
        cellReply.lblReply.text = reply

        
        return cellReply
        
        
        
//        self.arrReplies.append(reply)
//        let totalCounts = self.arrComments.count + self.arrReplies.count
//        self.lblCommentCounts.text = "\(totalCounts) Comments"
        
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField

}

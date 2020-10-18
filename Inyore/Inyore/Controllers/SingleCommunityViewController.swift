//
//  SingleCommunityViewController.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class SingleCommunityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imgCommunity: UIImageView!
    @IBOutlet weak var btnFollow: CustomButton!
    @IBOutlet weak var lblMembers: UILabel!
    @IBOutlet weak var communityDesc: UILabel!
    
    @IBOutlet weak var optionView: CustomView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblSingleCommunity: UITableView!
    @IBOutlet weak var tblSingleCommunityHeight: NSLayoutConstraint!
    
    @IBOutlet weak var btnTrending: UIButton!
    @IBOutlet weak var btnAll: UIButton!
    
    var myUser: [User]? {didSet {}}
    
    var community_id = Int()
    
    var lblCommunityTitle = String()
    
    var arrPopular_articles = [Articles]()
    var arrAll_articles = [Articles]()
    
    var isPopular_articles = false
    var isAll_articles = false
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.scrollView.delegate = self
        
        self.tblSingleCommunity.tableFooterView = UIView()
        
        self.lblMessage.isHidden = false
        self.optionView.isHidden = true
        
        self.callSingleCommunityAPI()
        
        self.isPopular_articles = true
        self.btnTrending.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon-active"), for: .normal)
        self.tblSingleCommunity.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        self.tblSingleCommunity.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tblSingleCommunity.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        if(keyPath == "contentSize"){

            if let newvalue = change?[.newKey]{
                let newsize  = newvalue as! CGSize
                self.tblSingleCommunityHeight.constant = newsize.height
            }
        }
    }
    
    //MARK:- Utility Methods
    @objc func refresh(){
        
        refreshControl.endRefreshing()
        callSingleCommunityAPI()
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
 
    @IBAction func btnFollowAction(_ sender: UIButton) {
        
        print("Follow")
        self.callFollowCommunityAPI(communityId: self.community_id) { (isSuccess) in
            
            if isSuccess == true{
                
                self.btnFollow.setTitle("Following", for: .normal)
            }
            else{
                
                self.btnFollow.setTitle("Follow", for: .normal)
            }
        }
        
    }
    
    @IBAction func btnCollectionAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon-active"), for: .normal)
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon"), for: .normal)
            
            self.isPopular_articles = true
            self.isAll_articles = false
            self.tblSingleCommunity.reloadData()
            
        }
        else{
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon-active"), for: .normal)
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon"), for: .normal)
            
            self.isPopular_articles = false
            self.isAll_articles = true
            self.tblSingleCommunity.reloadData()
        }
    }
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isPopular_articles == true{
            
            if self.arrPopular_articles.count == 0{
                
                self.optionView.isHidden = true
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                
                self.optionView.isHidden = false
                self.lblMessage.isHidden = true
                return self.arrPopular_articles.count
            }
        }
        else{
            
            if self.arrAll_articles.count == 0{
                
                self.optionView.isHidden = true
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                
                self.optionView.isHidden = false
                self.lblMessage.isHidden = true
                return self.arrAll_articles.count
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isPopular_articles == true{
            
            let popularArticles = self.arrPopular_articles[indexPath.row]
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(popularArticles.ar_image_link ?? "")"
            
            let cellSingleCommunity = tableView.dequeueReusableCell(withIdentifier: "cellSingleCommunity") as! SingleCommunityTableViewCell
            
            cellSingleCommunity.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
            
            cellSingleCommunity.lblCommunityTitle.text = "@\(self.lblCommunityTitle)"
            cellSingleCommunity.lblArticleTitle.text = popularArticles.ar_title
            
            let dateAsString = popularArticles.updated_at!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
            let date = formatter.date(from: dateAsString)!
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            cellSingleCommunity.lblArticleTime.text = "\(time) pst"
            
            cellSingleCommunity.lblArticleDescription.text = popularArticles.ar_description
            
            cellSingleCommunity.btnComment.setTitle("\(popularArticles.usercomments ?? 0)", for: .normal)
            cellSingleCommunity.btnComment.tag = indexPath.row
            cellSingleCommunity.btnComment.addTarget(self, action: #selector(self.btnCommentAction(btn:)), for: .touchUpInside)
            
            cellSingleCommunity.btnPraise.setTitle("\(popularArticles.userpraises ?? 0)", for: .normal)
            cellSingleCommunity.btnPraise.tag = indexPath.row
            cellSingleCommunity.btnPraise.addTarget(self, action: #selector(self.btnPraiseAction(btn:)), for: .touchUpInside)
            
            cellSingleCommunity.btnShare.tag = indexPath.row
            cellSingleCommunity.btnShare.addTarget(self, action: #selector(self.btnShareAction(btn:)), for: .touchUpInside)
            
            return cellSingleCommunity
        }
        else{
            
            let allArticles = self.arrAll_articles[indexPath.row]
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(allArticles.ar_image_link ?? "")"
            
            let cellSingleCommunity = tableView.dequeueReusableCell(withIdentifier: "cellSingleCommunity") as! SingleCommunityTableViewCell
            
            cellSingleCommunity.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
            
            cellSingleCommunity.lblCommunityTitle.text = "@\(self.lblCommunityTitle)"
            cellSingleCommunity.lblArticleTitle.text = allArticles.ar_title
            
            let dateAsString = allArticles.updated_at!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
            let date = formatter.date(from: dateAsString)!
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            cellSingleCommunity.lblArticleTime.text = "\(time) pst"
                        
            cellSingleCommunity.lblArticleDescription.text = allArticles.ar_description
            
            cellSingleCommunity.btnComment.setTitle("\(allArticles.usercomments ?? 0)", for: .normal)
            cellSingleCommunity.btnComment.tag = indexPath.row
            cellSingleCommunity.btnComment.addTarget(self, action: #selector(self.btnCommentAction(btn:)), for: .touchUpInside)
            
            cellSingleCommunity.btnPraise.setTitle("\(allArticles.userpraises ?? 0)", for: .normal)
            cellSingleCommunity.btnPraise.tag = indexPath.row
            cellSingleCommunity.btnPraise.addTarget(self, action: #selector(self.btnPraiseAction(btn:)), for: .touchUpInside)
            
            cellSingleCommunity.btnShare.tag = indexPath.row
            cellSingleCommunity.btnShare.addTarget(self, action: #selector(self.btnShareAction(btn:)), for: .touchUpInside)
            
            return cellSingleCommunity
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.isPopular_articles == true{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrPopular_articles[indexPath.row].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        else{
            
            print("IndexPath: ", indexPath.item)
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrAll_articles[indexPath.row].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    //MARK:- tableview cell button Actions
    @objc func btnCommentAction(btn: UIButton){
        
        if self.isPopular_articles == true{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrPopular_articles[btn.tag].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        else{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrAll_articles[btn.tag].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
    }
    
    @objc func btnPraiseAction(btn: UIButton){
        
        if self.isPopular_articles == true{
            
            let id = self.arrPopular_articles[btn.tag].id!
            print("All Popular id: ", id)
            
            self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    let praiseCount = self.arrPopular_articles[btn.tag].userpraises!
                    let increment = praiseCount + 1
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblSingleCommunity.cellForRow(at: index) as! SingleCommunityTableViewCell
                    cell.btnPraise.setTitle("\(increment)", for: .normal)
                }
            }
            
        }
        else{
            
            let id = self.arrAll_articles[btn.tag].id!
            print("All Articles id: ", id)
            
            self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    let praiseCount = self.arrAll_articles[btn.tag].userpraises!
                    let increment = praiseCount + 1
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblSingleCommunity.cellForRow(at: index) as! SingleCommunityTableViewCell
                    cell.btnPraise.setTitle("\(increment)", for: .normal)
                }
            }
        }
    }
    
    @objc func btnShareAction(btn: UIButton){
        
        if self.isPopular_articles == true{
         
            let id = self.arrPopular_articles[btn.tag].id!
            let text = "https://www.inyore.com/article/\(id)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else{
            
            let id = self.arrAll_articles[btn.tag].id!
            let text = "https://www.inyore.com/article/\(id)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
    }
    
    //MARK: API Methods
    func callSingleCommunityAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        APIHandler.sharedInstance.singleCommunity(communityId: "\(self.community_id)", api_token: api_token) { (isSuccess, response ) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        if data["already_joined"] as! Int == 0{
                            
                            self.btnFollow.setTitle("Follow", for: .normal)
                        }
                        else{
                            
                            self.btnFollow.setTitle("Following", for: .normal)
                        }
                        
                        self.lblMembers.text = "Members \(data["totel_members"] as! Int)"
                        
                        let single_community = data["single_community"] as! [String : Any]
                        self.lblCommunityTitle = single_community["cy_title"] as! String
                        
                        let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(single_community["cy_image_link"] as? String ?? "")"
                        self.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
                        self.communityDesc.text = single_community["cy_description"] as? String
                        
                        
                        let popular_articles = data["popular_articles"] as! [[String : Any]]
                        self.arrPopular_articles = (popular_articles).map({Articles.map(JSONObject: $0, context: nil)})
                        self.tblSingleCommunity.reloadData()
                        
                        let all_articles = data["all_articles"] as! [[String : Any ]]
                        self.arrAll_articles = (all_articles).map({Articles.map(JSONObject: $0, context: nil)})
                        self.tblSingleCommunity.reloadData()
                        
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
    
    func callPraiseArticleAPI(truth_id : Int, completionHandler : @escaping( _ result: Bool) -> Void){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        
        let param = ["api_token": api_token, "truth_id": "\(truth_id)"]
        APIHandler.sharedInstance.praiseAnArticle(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    completionHandler(true)
//                    let msg = response!["msg"] as! String
//                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: msg, delegate: self)
                }
                else{
                    
                    completionHandler(false)
//                    let message = response!["msg"] as! String
//                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: message, delegate: self)
                }
            }
            else{
                
                completionHandler(false)
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    func callFollowCommunityAPI(communityId: Int, completionHandler : @escaping( _ result: Bool) -> Void){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        self.myUser = User.readUserFromArchive()
        let api_token = self.myUser![0].api_token!
        let param = ["api_token": api_token, "communityid": "\(communityId)"]
        
        APIHandler.sharedInstance.followCommunity(param: param) { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    completionHandler(true)
                }
                else{
                    
                    completionHandler(false)
                    let message = response!["msg"] as! String
                    print("Message: ", message)
                }
            }
            else{
                
                AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: NSLocalizedString("error_400", comment: ""), delegate: self)
            }
        }
    }
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField

}

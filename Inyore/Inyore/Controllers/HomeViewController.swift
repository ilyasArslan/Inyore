//
//  HomeViewController.swift
//  Inyore
//
//  Created by Arslan on 23/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate {

    //MARK: Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var tbllatestTruths: UITableView!
    @IBOutlet weak var tbllatestTruthsHeight: NSLayoutConstraint!
        
    @IBOutlet weak var newsFeedView: UIView!
    @IBOutlet weak var newsFeedCV: UICollectionView!
    
    @IBOutlet weak var truthsView: CustomView!
    @IBOutlet weak var btnTrendingTruths: UIButton!
    @IBOutlet weak var btnAllTruths: UIButton!
    @IBOutlet weak var btnTop3Truth: UIButton!
    
    @IBOutlet weak var tblArticles: UITableView!
    @IBOutlet weak var tblArticlesHeight: NSLayoutConstraint!
    
    var refreshControl = UIRefreshControl()
    
    var myUser: [User]? {didSet {}}
    
    var arrLatestTruths = [latestTruths]()
    var arrNewsFeed = [NewsFeed]()
    
    var arrArticles = [Articles]()
    var arrAllArticles = [Articles]()
    var arrPopularArticles = [Articles]()
    
    var isTrending_articles = false
    var isAll_articles = false
    var isPopular_articles = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.lblMessage.isHidden = false
        self.newsFeedView.isHidden = true
        self.truthsView.isHidden = true
        
        self.tbllatestTruths.tableFooterView = UIView()
        self.tblArticles.tableFooterView = UIView()
        
        self.scrollView.delegate = self
        
        self.isTrending_articles = true
        self.btnTrendingTruths.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.btnTrendingTruths.setImage(UIImage(named: "tab-icon-active"), for: .normal)
        
        self.callHomeAPI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        self.tbllatestTruths.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        self.tblArticles.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tbllatestTruths.removeObserver(self, forKeyPath: "contentSize")
        self.tblArticles.removeObserver(self, forKeyPath: "contentSize")
        super.viewWillDisappear(true)

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
        if(keyPath == "contentSize"){
            self.tbllatestTruthsHeight.constant = self.tbllatestTruths.contentSize.height
            print("Truth Height: ", self.tbllatestTruthsHeight!)
            
            self.tblArticlesHeight.constant = self.tblArticles.contentSize.height
            print("Article Height: ", self.tblArticlesHeight!)
        }

    }
    
    //MARK:- Utility Methods
    @objc func refresh(){
        
        refreshControl.endRefreshing()
        callHomeAPI()
    }
    
    
    //MARK:- Button Action
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
    
    @IBAction func btnTruthsAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            
            self.btnTrendingTruths.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnTrendingTruths.setImage(UIImage(named: "tab-icon-active"), for: .normal)
            
            self.btnAllTruths.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAllTruths.setImage(UIImage(named: "all-loop-icon"), for: .normal)
            
            self.btnTop3Truth.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTop3Truth.setImage(UIImage(named: "new-art-icon"), for: .normal)
            
            self.isTrending_articles = true
            self.isAll_articles = false
            self.isPopular_articles = false
            
            self.tblArticles.reloadData()
//            self.tblArticlesHeight.constant = self.tblArticles.contentSize.height
            
        }
        else if sender.tag == 2{
            
            self.btnTrendingTruths.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrendingTruths.setImage(UIImage(named: "tab-icon"), for: .normal)
            
            self.btnAllTruths.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnAllTruths.setImage(UIImage(named: "all-loop-icon-active"), for: .normal)
            
            self.btnTop3Truth.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTop3Truth.setImage(UIImage(named: "new-art-icon"), for: .normal)
            
            self.isTrending_articles = false
            self.isAll_articles = true
            self.isPopular_articles = false
            
            self.tblArticles.reloadData()
            
        }
        else{
            
            self.btnTrendingTruths.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrendingTruths.setImage(UIImage(named: "tab-icon"), for: .normal)
            
            self.btnAllTruths.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAllTruths.setImage(UIImage(named: "all-loop-icon"), for: .normal)
            
            self.btnTop3Truth.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnTop3Truth.setImage(UIImage(named: "new-art-icon-active"), for: .normal)
            
            self.isTrending_articles = false
            self.isAll_articles = false
            self.isPopular_articles = true
            
            self.tblArticles.reloadData()
            
        }
    }
    
    //MARK:- DELEGATE METHODS
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        let contentOffset = self.scrollView.contentOffset.y
//
//        let tblTruthsContentOffset = self.tbllatestTruths.contentOffset.y
//        let newsFeedContentOffset = self.newsFeedCV.contentOffset.y
//        let tblArticlesContentOffset = self.tblArticles.contentOffset.y
//
//       // print("contentOffset: ", contentOffset)
//
//        print("tblTruthsContentOffset: ", tblTruthsContentOffset)
//
//        print("newsFeedContentOffset: ", newsFeedContentOffset)
//
//        print("tblArticlesContentOffset: ", tblArticlesContentOffset)
        
        
//        if contentOffset < tblTruthsContentOffset{
//            self.lblTitle.text = "Latest Truths"
//        }
//
//        else if contentOffset > tblTruthsContentOffset{
//            self.lblTitle.text = "Newsfeed"
//        }
            
//        else if contentOffset == tblArticlesContentOffset {
//            self.lblTitle.text = "Truths"
//        }

    }
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tbllatestTruths{
            
            return self.arrLatestTruths.count
            
        }
        else{
            
            if isTrending_articles == true{
                
                return self.arrArticles.count
            }
            else if isAll_articles == true{
                
                return self.arrAllArticles.count
            }
            else{
                
                return self.arrPopularArticles.count
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tbllatestTruths{
            
            let latest_Truths = self.arrLatestTruths[indexPath.row]
            let communities = latest_Truths.communities!
            
            let cellFeed = tableView.dequeueReusableCell(withIdentifier: "cellFeed") as! FeedTableViewCell
            
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(latest_Truths.ar_image_link ?? "")"
            
            cellFeed.ar_image_link.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
            
            if communities.count == 0{
                
                cellFeed.lblCommunityTitle.text = ""
            }
            else{
                
                cellFeed.lblCommunityTitle.text = "@\(communities[0].cy_title ?? "")"
            }
            
            cellFeed.lblTitle.text = latest_Truths.ar_title
            
            let dateAsString = latest_Truths.updated_at!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
            let date = formatter.date(from: dateAsString)!
            formatter.dateFormat = "hh:mm a"
            let time = formatter.string(from: date)
            
            cellFeed.lblTime.text = "\(time) pst"
            cellFeed.lblDesc.text = latest_Truths.ar_description
            
            cellFeed.btnComment.setTitle("\(latest_Truths.usercomments ?? 0)", for: .normal)
            cellFeed.btnComment.tag = indexPath.row
            cellFeed.btnComment.addTarget(self, action: #selector(self.btCommentAction(btn:)), for: .touchUpInside)

            cellFeed.btnPraise.setTitle("\(latest_Truths.userpraises ?? 0)", for: .normal)
            cellFeed.btnPraise.tag = indexPath.row
            cellFeed.btnPraise.addTarget(self, action: #selector(self.btnPraiseAction(btn:)), for: .touchUpInside)
            
            cellFeed.btnShare.tag = indexPath.row
            cellFeed.btnShare.addTarget(self, action: #selector(self.btnShare(btn:)), for: .touchUpInside)
            
            return cellFeed
            
        }
        else{
            
            if self.isTrending_articles == true{
                
                let articles = self.arrArticles[indexPath.row]
                let communities = articles.communities!
                
                let cellTruth = tableView.dequeueReusableCell(withIdentifier: "cellTruth") as! TruthTableViewCell
                
                let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(articles.ar_image_link ?? "")"
                cellTruth.ar_image_link.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
                
                if communities.count == 0{
                    
                    cellTruth.lblCommunityTitle.text = ""
                }
                else{
                    
                    cellTruth.lblCommunityTitle.text = "@\(communities[0].cy_title ?? "")"
                }
                
                cellTruth.lblTitle.text = articles.ar_title
                
                let dateAsString = articles.updated_at!
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
                let date = formatter.date(from: dateAsString)!
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: date)
                
                cellTruth.lblTime.text = "\(time) pst"
                cellTruth.lblDesc.text = articles.ar_description
                
                cellTruth.btnComment.setTitle("\(articles.usercomments ?? 0)", for: .normal)
                cellTruth.btnComment.tag = indexPath.row
                cellTruth.btnComment.addTarget(self, action: #selector(self.btnCommentArticleAction(btn:)), for: .touchUpInside)

                cellTruth.btnPraise.setTitle("\(articles.userpraises ?? 0)", for: .normal)
                cellTruth.btnPraise.tag = indexPath.row
                cellTruth.btnPraise.addTarget(self, action: #selector(self.btnPraiseArticleAction(btn:)), for: .touchUpInside)
                
                cellTruth.btnShare.tag = indexPath.row
                cellTruth.btnShare.addTarget(self, action: #selector(self.btnShareArticleAction(btn:)), for: .touchUpInside)
                
                return cellTruth
            }
            else if self.isAll_articles == true{
                
                let articles = self.arrAllArticles[indexPath.row]
                let communities = articles.communities!
                
                let cellTruth = tableView.dequeueReusableCell(withIdentifier: "cellTruth") as! TruthTableViewCell
                
                let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(articles.ar_image_link ?? "")"
                cellTruth.ar_image_link.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
                
                if communities.count == 0{
                    
                    cellTruth.lblCommunityTitle.text = ""
                }
                else{
                    
                    cellTruth.lblCommunityTitle.text = "@\(communities[0].cy_title ?? "")"
                }
                
                cellTruth.lblTitle.text = articles.ar_title
                
                let dateAsString = articles.updated_at!
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
                let date = formatter.date(from: dateAsString)!
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: date)
                
                cellTruth.lblTime.text = "\(time) pst"
                cellTruth.lblDesc.text = articles.ar_description
                
                cellTruth.btnComment.setTitle("\(articles.usercomments ?? 0)", for: .normal)
                cellTruth.btnComment.tag = indexPath.row
                cellTruth.btnComment.addTarget(self, action: #selector(self.btnCommentArticleAction(btn:)), for: .touchUpInside)

                cellTruth.btnPraise.setTitle("\(articles.userpraises ?? 0)", for: .normal)
                cellTruth.btnPraise.tag = indexPath.row
                cellTruth.btnPraise.addTarget(self, action: #selector(self.btnPraiseArticleAction(btn:)), for: .touchUpInside)
                
                cellTruth.btnShare.tag = indexPath.row
                cellTruth.btnShare.addTarget(self, action: #selector(self.btnShareArticleAction(btn:)), for: .touchUpInside)
                
                return cellTruth
            }
            else{
                
                let articles = self.arrPopularArticles[indexPath.row]
                let communities = articles.communities!
                
                let cellTruth = tableView.dequeueReusableCell(withIdentifier: "cellTruth") as! TruthTableViewCell
                
                let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(articles.ar_image_link ?? "")"
                cellTruth.ar_image_link.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
                
                if communities.count == 0{
                    
                    cellTruth.lblCommunityTitle.text = ""
                }
                else{
                    
                    cellTruth.lblCommunityTitle.text = "@\(communities[0].cy_title ?? "")"
                }
                
                
                cellTruth.lblTitle.text = articles.ar_title
                
                let dateAsString = articles.updated_at!
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.timeZone = TimeZone(abbreviation: "PST")//Add this
                let date = formatter.date(from: dateAsString)!
                formatter.dateFormat = "hh:mm a"
                let time = formatter.string(from: date)
                
                cellTruth.lblTime.text = "\(time) pst"
                cellTruth.lblDesc.text = articles.ar_description
                
                cellTruth.btnComment.setTitle("\(articles.usercomments ?? 0)", for: .normal)
                cellTruth.btnComment.tag = indexPath.row
                cellTruth.btnComment.addTarget(self, action: #selector(self.btnCommentArticleAction(btn:)), for: .touchUpInside)

                cellTruth.btnPraise.setTitle("\(articles.userpraises ?? 0)", for: .normal)
                cellTruth.btnPraise.tag = indexPath.row
                cellTruth.btnPraise.addTarget(self, action: #selector(self.btnPraiseArticleAction(btn:)), for: .touchUpInside)
                
                cellTruth.btnShare.tag = indexPath.row
                cellTruth.btnShare.addTarget(self, action: #selector(self.btnShareArticleAction(btn:)), for: .touchUpInside)
                
                return cellTruth
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.tbllatestTruths{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            navigationController?.pushViewController(feedDetailVC, animated: true)
            
        }
        else{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            navigationController?.pushViewController(feedDetailVC, animated: true)
            
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if tableView == self.tbllatestTruths{

            return UITableView.automaticDimension
        }
        else{

            return UITableView.automaticDimension
        }

    }
    
    //MARK:- tableView cells buttons
    @objc func btCommentAction(btn: UIButton){
        
        let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
        feedDetailVC.truthId = self.arrLatestTruths[btn.tag].id!
        navigationController?.pushViewController(feedDetailVC, animated: true)
    }
    
    @objc func btnCommentArticleAction(btn: UIButton){
        
        if self.isTrending_articles == true{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrArticles[btn.tag].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        else if self.isAll_articles == true{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrAllArticles[btn.tag].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        else if self.isPopular_articles == true{
            
            let feedDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "feedDetailVC") as! FeedDetailViewController
            feedDetailVC.truthId = self.arrPopularArticles[btn.tag].id!
            navigationController?.pushViewController(feedDetailVC, animated: true)
        }
        
    }
    
    @objc func btnShare(btn: UIButton){
        
        let id = self.arrLatestTruths[btn.tag].id!
        let text = "https://www.inyore.com/article/\(id)"
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @objc func btnPraiseAction(btn: UIButton){
        
        let id = self.arrLatestTruths[btn.tag].id!
        print("Id: ", id)
        
        self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
            
            if isSuccess == true{
                
                let praiseCount = self.arrLatestTruths[btn.tag].userpraises!
                let increment = praiseCount + 1
                let index = IndexPath(row: btn.tag, section: 0)
                let cell = self.tbllatestTruths.cellForRow(at: index) as! FeedTableViewCell
                cell.btnPraise.setTitle("\(increment)", for: .normal)
            }
        }
        
    }
    
    @objc func btnPraiseArticleAction(btn: UIButton){
        
        if self.isTrending_articles == true{
            
            let id = self.arrArticles[btn.tag].id!
            print("Article id: ", id)
            
            self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    let praiseCount = self.arrArticles[btn.tag].userpraises!
                    let increment = praiseCount + 1
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblArticles.cellForRow(at: index) as! TruthTableViewCell
                    cell.btnPraise.setTitle("\(increment)", for: .normal)
                }
            }
        }
        else if self.isAll_articles == true{
            
            let id = self.arrAllArticles[btn.tag].id!
            print("All Article id: ", id)
            
            self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    let praiseCount = self.arrAllArticles[btn.tag].userpraises!
                    let increment = praiseCount + 1
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblArticles.cellForRow(at: index) as! TruthTableViewCell
                    cell.btnPraise.setTitle("\(increment)", for: .normal)
                }
            }
        }
        else{
            
            let id = self.arrPopularArticles[btn.tag].id!
            print("All Popular id: ", id)
            
            self.callPraiseArticleAPI(truth_id: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    let praiseCount = self.arrPopularArticles[btn.tag].userpraises!
                    let increment = praiseCount + 1
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblArticles.cellForRow(at: index) as! TruthTableViewCell
                    cell.btnPraise.setTitle("\(increment)", for: .normal)
                }
            }
        }
    }
    
    @objc func btnShareArticleAction(btn: UIButton){
        
        if self.isTrending_articles == true{
            
            let id = self.arrArticles[btn.tag].id!
            let text = "https://www.inyore.com/article/\(id)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else if self.isAll_articles == true{
            
            let id = self.arrAllArticles[btn.tag].id!
            let text = "https://www.inyore.com/article/\(id)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        else{
            
            let id = self.arrPopularArticles[btn.tag].id!
            let text = "https://www.inyore.com/article/\(id)"
            let textToShare = [text]
            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
            
            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
    //MARK: API Methods
    func callHomeAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.home { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        self.lblMessage.isHidden = true
                        self.newsFeedView.isHidden = false
                        self.truthsView.isHidden = false
                        
                        let news_feed = data["news_feed"] as! [String : Any]
                        let results = news_feed["results"] as! [[String : Any]]
                        self.arrNewsFeed = (results).map({NewsFeed.map(JSONObject: $0, context: nil)})
                        self.newsFeedCV.reloadData()
                        
                        
                        let latest_truths = data["latest_truths"] as! [[String : Any]]
                        self.arrLatestTruths = (latest_truths).map({latestTruths.map(JSONObject: $0, context: nil)})
                        self.tbllatestTruths.reloadData()
//                        self.tbllatestTruthsHeight.constant = self.tbllatestTruths.contentSize.height
                        
                        
                        let trending_articles = data["trending_articles"] as! [[String : Any]]
                        self.arrArticles = (trending_articles).map({Articles.map(JSONObject: $0, context: nil)})
                        self.tblArticles.reloadData()
//                        self.tblArticlesHeight.constant = self.tblArticles.contentSize.height
                        
                        let all_articles = data["all_articles"] as! [[String : Any]]
                        self.arrAllArticles = (all_articles).map({Articles.map(JSONObject: $0, context: nil)})
                        self.tblArticles.reloadData()
//                        self.tblArticlesHeight.constant = self.tblArticles.contentSize.height
                        
                        let popular_articles = data["popular_articles"] as! [[String : Any]]
                        self.arrPopularArticles = (popular_articles).map({Articles.map(JSONObject: $0, context: nil)})
                        self.tblArticles.reloadData()
//                        self.tblArticlesHeight.constant = self.tblArticles.contentSize.height
                        
                        
                    }
                    else{
                        
                        self.lblMessage.isHidden = false
                        self.newsFeedView.isHidden = true
                        self.truthsView.isHidden = true
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
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrNewsFeed.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let news_feed = self.arrNewsFeed[indexPath.item]
        let imgUrl = news_feed.thumbnail_standard ?? ""
        
        let cellNews = collectionView.dequeueReusableCell(withReuseIdentifier: "cellNews", for: indexPath) as! NewsFeedCollectionViewCell
        
        cellNews.imgNews.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "logo_icon"))
        cellNews.lblNewsTitle.text = news_feed.title
        cellNews.lblNewsDesc.text = news_feed.abstract
        cellNews.btnViewArticle.tag = indexPath.item
        cellNews.btnViewArticle.addTarget(self, action: #selector(self.viewArticle(btn:)), for: .touchUpInside)
        
        return cellNews
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.newsFeedCV.frame.width / 1)
        return CGSize(width: width, height: 240)
    }
    
    //MARK:- btn View Article
    @objc func viewArticle(btn: UIButton){
        
        let openUrl = self.arrNewsFeed[btn.tag].url ?? ""
        if let url = URL(string: openUrl) {
            UIApplication.shared.open(url)
        }
        
    }
    
}

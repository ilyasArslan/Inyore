//
//  ExploreCommunitiesViewController.swift
//  Inyore
//
//  Created by Arslan on 01/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class ExploreCommunitiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnNew: UIButton!
    @IBOutlet weak var btnTrending: UIButton!
    @IBOutlet weak var btnCommunities: UIButton!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var tblCommunities: UITableView!
    
    var arrAll_communities = [ExploreCommunities]()
    var arrNew_communities = [ExploreCommunities]()
    var arrTrending_communities = [ExploreCommunities]()
    var arrMy_communities = [ExploreCommunities]()
    
    var isAll_communities = false
    var isNew_communities = false
    var isTrending_communities = false
    var isMy_communities = false
    
    var arrCommunityIds = [Int]()
    
    var myUser: [User]? {didSet {}}
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        self.arrAll_communities.removeAll()
        self.arrNew_communities.removeAll()
        self.arrTrending_communities.removeAll()
        self.arrMy_communities.removeAll()
        
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
        self.tblCommunities.tableFooterView = UIView()
        self.lblMessage.isHidden = false

        self.callExploreCommunitiesAPI()
        
        self.isAll_communities = true
        self.btnAll.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon-active"), for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tblCommunities.refreshControl = refreshControl
    }
    
    //MARK:- Utility Methods
    @objc func refresh(){
        
        refreshControl.endRefreshing()
        callExploreCommunitiesAPI()
    }
    
    //MARK:- Button Action
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
    
    @IBAction func btnCollectionAction(_ sender: UIButton) {
        
        if sender.tag == 1{
            print("All")
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon-active"), for: .normal)
            
            self.btnNew.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnNew.setImage(#imageLiteral(resourceName: "new-art-icon"), for: .normal)
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon"), for: .normal)
            
            self.btnCommunities.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnCommunities.setImage(#imageLiteral(resourceName: "my-community-icon"), for: .normal)
            
            self.isAll_communities = true
            self.isTrending_communities = false
            self.isNew_communities = false
            self.isMy_communities = false
            self.tblCommunities.reloadData()
            
        }
        else if sender.tag == 2{
            print("New")
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon"), for: .normal)
            
            self.btnNew.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnNew.setImage(#imageLiteral(resourceName: "new-art-icon-active"), for: .normal)
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon"), for: .normal)
            
            self.btnCommunities.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnCommunities.setImage(#imageLiteral(resourceName: "my-community-icon"), for: .normal)
            
            self.isAll_communities = false
            self.isNew_communities = true
            self.isTrending_communities = false
            self.isMy_communities = false
            self.tblCommunities.reloadData()
            
        }
        else if sender.tag == 3{
            print("Trending")
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon"), for: .normal)
            
            self.btnNew.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnNew.setImage(#imageLiteral(resourceName: "new-art-icon"), for: .normal)
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon-active"), for: .normal)
            
            self.btnCommunities.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnCommunities.setImage(#imageLiteral(resourceName: "my-community-icon"), for: .normal)
            
            self.isAll_communities = false
            self.isNew_communities = false
            self.isTrending_communities = true
            self.isMy_communities = false
            self.tblCommunities.reloadData()
            
        }
        else{
            print("My Communities")
            
            self.btnAll.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnAll.setImage(#imageLiteral(resourceName: "all-loop-icon"), for: .normal)
            
            self.btnNew.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnNew.setImage(#imageLiteral(resourceName: "new-art-icon"), for: .normal)
            
            self.btnTrending.setTitleColor(#colorLiteral(red: 0.6039215686, green: 0.6039215686, blue: 0.6039215686, alpha: 1), for: .normal)
            self.btnTrending.setImage(#imageLiteral(resourceName: "tab-icon"), for: .normal)
            
            self.btnCommunities.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
            self.btnCommunities.setImage(#imageLiteral(resourceName: "my-community-icon-active"), for: .normal)
            
            self.isAll_communities = false
            self.isNew_communities = false
            self.isTrending_communities = false
            self.isMy_communities = true
            self.tblCommunities.reloadData()
            
        }
        
    }
    //MARK: API Methods
    func callExploreCommunitiesAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.exploreCommunities { (isSuccess, response) in
            
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    if let data = response!["data"] as? NSDictionary{
                        
                        self.lblMessage.isHidden = true
                        
                        let all_communities = data["all_communities"] as! [[String : Any]]
                        self.arrAll_communities = (all_communities).map({ExploreCommunities.map(JSONObject: $0, context: nil)})
                        self.tblCommunities.reloadData()
                        
                        let new_communities = data["new_communities"] as! [[String : Any]]
                        self.arrNew_communities = (new_communities).map({ExploreCommunities.map(JSONObject: $0, context: nil)})
                        self.tblCommunities.reloadData()

                        let trending_communities = data["trending_communities"] as! [[String : Any]]
                        self.arrTrending_communities = (trending_communities).map({ExploreCommunities.map(JSONObject: $0, context: nil)})
                        self.tblCommunities.reloadData()

                        let my_communities = data["my_communities"] as! [[String : Any]]
                        self.arrMy_communities = (my_communities).map({ExploreCommunities.map(JSONObject: $0, context: nil)})
                        self.tblCommunities.reloadData()
                        
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
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isAll_communities == true{
            
            if self.arrAll_communities.count == 0{
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                self.lblMessage.isHidden = true
                return self.arrAll_communities.count
            }
            
        }
        else if self.isNew_communities == true{
            
            if self.arrNew_communities.count == 0{
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                self.lblMessage.isHidden = true
                return self.arrNew_communities.count
            }
            
        }
        else if self.isTrending_communities == true{
            
            if self.arrTrending_communities.count == 0{
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                self.lblMessage.isHidden = true
                return self.arrTrending_communities.count
            }
            
        }
        else{
            
            if self.arrMy_communities.count == 0{
                self.lblMessage.isHidden = false
                return 0
            }
            else{
                self.lblMessage.isHidden = true
                return self.arrMy_communities.count
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isAll_communities == true{
            
            let community = self.arrAll_communities[indexPath.row]
            let id = community.id!
            
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            
            print("Image Url: ", imgUrl)
            
            let cellCommunities = tableView.dequeueReusableCell(withIdentifier: "cellCommunities") as! CommunitiesTableViewCell
            
            cellCommunities.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "inyore_Final_Logo"))
            cellCommunities.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellCommunities.lblCoomunityMember.text = "\(community.members ?? 0) members"
            
            cellCommunities.lblCoomunityDesc.text = community.cy_description
            cellCommunities.lblCoomunityDesc.attributedText = cellCommunities.lblCoomunityDesc.text?.htmlAttributed(family: "Trebuchet MS", size: 15)
            cellCommunities.lblCoomunityDesc.enabledTypes = [.mention, .hashtag, .url]
            cellCommunities.lblCoomunityDesc.handleURLTap { url in UIApplication.shared.open(url) }
            
            
            cellCommunities.btnFollow.tag = indexPath.row
            cellCommunities.btnFollow.addTarget(self, action: #selector(self.btnFollow(btn:)), for: .touchUpInside)
            
            if self.arrCommunityIds.contains(id){
                cellCommunities.btnFollow.setTitle("Following", for: .normal)
            }
            else{
                
                cellCommunities.btnFollow.setTitle("Follow", for: .normal)
            }
            
            return cellCommunities
            
        }
        else if self.isNew_communities == true{
            
            let community = self.arrNew_communities[indexPath.row]
            let id = community.id!
            
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            
            let cellCommunities = tableView.dequeueReusableCell(withIdentifier: "cellCommunities") as! CommunitiesTableViewCell
            
            cellCommunities.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "inyore_Final_Logo"))
            cellCommunities.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellCommunities.lblCoomunityMember.text = "\(community.members ?? 0) members"
            
            cellCommunities.lblCoomunityDesc.text = community.cy_description
            cellCommunities.lblCoomunityDesc.attributedText = cellCommunities.lblCoomunityDesc.text?.htmlAttributed(family: "Trebuchet MS", size: 15)
            cellCommunities.lblCoomunityDesc.enabledTypes = [.mention, .hashtag, .url]
            cellCommunities.lblCoomunityDesc.handleURLTap { url in UIApplication.shared.open(url) }
            
            cellCommunities.btnFollow.tag = indexPath.row
            cellCommunities.btnFollow.addTarget(self, action: #selector(self.btnFollow(btn:)), for: .touchUpInside)
            
            if self.arrCommunityIds.contains(id){
                cellCommunities.btnFollow.setTitle("Following", for: .normal)
            }
            else{
                
                cellCommunities.btnFollow.setTitle("Follow", for: .normal)
            }
            
            return cellCommunities
            
        }
        else if self.isTrending_communities == true{
            
            let community = self.arrTrending_communities[indexPath.row]
            let id = community.id!
            
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            
            let cellCommunities = tableView.dequeueReusableCell(withIdentifier: "cellCommunities") as! CommunitiesTableViewCell
            
            cellCommunities.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "inyore_Final_Logo"))
            cellCommunities.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellCommunities.lblCoomunityMember.text = "\(community.members ?? 0) members"
            
            cellCommunities.lblCoomunityDesc.text = community.cy_description
            cellCommunities.lblCoomunityDesc.attributedText = cellCommunities.lblCoomunityDesc.text?.htmlAttributed(family: "Trebuchet MS", size: 15)
            cellCommunities.lblCoomunityDesc.enabledTypes = [.mention, .hashtag, .url]
            cellCommunities.lblCoomunityDesc.handleURLTap { url in UIApplication.shared.open(url) }
            
            cellCommunities.btnFollow.tag = indexPath.row
            cellCommunities.btnFollow.addTarget(self, action: #selector(self.btnFollow(btn:)), for: .touchUpInside)
            
            if self.arrCommunityIds.contains(id){
                cellCommunities.btnFollow.setTitle("Following", for: .normal)
            }
            else{
                
                cellCommunities.btnFollow.setTitle("Follow", for: .normal)
            }
            
            return cellCommunities
            
        }
        else{
            
            let community = self.arrMy_communities[indexPath.row]
            let id = community.id!
            
            let imgUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/community_header/\(community.cy_image_link ?? "")"
            
            let cellMyCommunities = tableView.dequeueReusableCell(withIdentifier: "cellMyCommunities") as! MyCommunitiyTableViewCell
            
            cellMyCommunities.imgCommunity.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "inyore_Final_Logo"))
            cellMyCommunities.lblCommunityTitle.text = "@\(community.cy_title ?? "")"
            cellMyCommunities.lblCommunityMember.text = "\(community.members ?? 0) members"
            
            cellMyCommunities.lblCommunityDesc.text = community.cy_description
            cellMyCommunities.lblCommunityDesc.attributedText = cellMyCommunities.lblCommunityDesc.text?.htmlAttributed(family: "Trebuchet MS", size: 15)
            cellMyCommunities.lblCommunityDesc.enabledTypes = [.mention, .hashtag, .url]
            cellMyCommunities.lblCommunityDesc.handleURLTap { url in UIApplication.shared.open(url) }
            
            cellMyCommunities.btnFolllowing.tag = indexPath.row
            cellMyCommunities.btnFolllowing.addTarget(self, action: #selector(self.btnFollow(btn:)), for: .touchUpInside)
            
            if self.arrCommunityIds.contains(id){
                cellMyCommunities.btnFolllowing.setTitle("Follow", for: .normal)
            }
            else{
                
                cellMyCommunities.btnFolllowing.setTitle("Following", for: .normal)
            }
            
            return cellMyCommunities
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if self.isAll_communities == true{
            
            let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
            singleCommunityVC.community_id = self.arrAll_communities[indexPath.row].id!
            singleCommunityVC.communityTitle = self.arrAll_communities[indexPath.row].cy_title!
            navigationController?.pushViewController(singleCommunityVC, animated: true)
        }
        else if self.isNew_communities == true{
            
            let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
            singleCommunityVC.community_id = self.arrNew_communities[indexPath.row].id!
            singleCommunityVC.communityTitle = self.arrNew_communities[indexPath.row].cy_title!
            navigationController?.pushViewController(singleCommunityVC, animated: true)
        }
        else if self.isTrending_communities == true{
            
            let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
            singleCommunityVC.community_id = self.arrTrending_communities[indexPath.row].id!
            singleCommunityVC.communityTitle = self.arrTrending_communities[indexPath.row].cy_title!
            navigationController?.pushViewController(singleCommunityVC, animated: true)
        }
        else{
            
            let singleCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "singleCommunityVC") as! SingleCommunityViewController
            singleCommunityVC.community_id = self.arrMy_communities[indexPath.row].id!
            singleCommunityVC.communityTitle = self.arrMy_communities[indexPath.row].cy_title!
            navigationController?.pushViewController(singleCommunityVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isAll_communities == true{
            
            return UITableView.automaticDimension
        }
        else if isNew_communities == true{
            
            return UITableView.automaticDimension
        }
        else if isTrending_communities == true{
            
            return UITableView.automaticDimension
        }
        else{
            
            return UITableView.automaticDimension
        }
        
    }
    
    //MARK:- tableView cell button Actions
    @objc func btnFollow(btn: UIButton){
        
        if self.isAll_communities == true{
            
            let id = self.arrAll_communities[btn.tag].id!
            self.callFollowCommunityAPI(communityId: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    self.arrCommunityIds.append(id)
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Following", for: .normal)
                    
                }
                else{
                    
                    self.arrCommunityIds = self.arrCommunityIds.filter{$0 != id}
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Follow", for: .normal)
                }
            }
        }
        else if self.isNew_communities == true{
            
            let id = self.arrNew_communities[btn.tag].id!
            self.callFollowCommunityAPI(communityId: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    self.arrCommunityIds.append(id)
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Following", for: .normal)
                }
                else{
                    
                    self.arrCommunityIds = self.arrCommunityIds.filter{$0 != id}
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Follow", for: .normal)
                }
            }
        }
        else if self.isTrending_communities == true{
            
            let id = self.arrTrending_communities[btn.tag].id!
            self.callFollowCommunityAPI(communityId: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    self.arrCommunityIds.append(id)
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Following", for: .normal)
                }
                else{
                    
                    self.arrCommunityIds = self.arrCommunityIds.filter{$0 != id}
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! CommunitiesTableViewCell
                    cell.btnFollow.setTitle("Follow", for: .normal)
                }
            }
        }
        else{
            
            let id = self.arrMy_communities[btn.tag].id!
            self.callFollowCommunityAPI(communityId: id) { (isSuccess) in
                
                if isSuccess == true{
                    
                    self.arrCommunityIds = self.arrCommunityIds.filter{$0 != id}
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! MyCommunitiyTableViewCell
                    cell.btnFolllowing.setTitle("Following", for: .normal)
                }
                else{
                    
                    self.arrCommunityIds.append(id)
                    let index = IndexPath(row: btn.tag, section: 0)
                    let cell = self.tblCommunities.cellForRow(at: index) as! MyCommunitiyTableViewCell
                    cell.btnFolllowing.setTitle("Follow", for: .normal)
                }
            }
        }
    }
    
    //MARK:- follow/unfollow API
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

//
//  MenuViewController.swift
//  Inyore
//
//  Created by Arslan on 22/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Outlets
    
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var tblMenu: UITableView!
    @IBOutlet weak var tblMenuHeight: NSLayoutConstraint!
    
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblMinutes: UILabel!
    @IBOutlet weak var lblSeconds: UILabel!
    
    var myUser: [User]? {didSet {}}
    var setViewWidth = CGFloat()
    var arrMenu = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startTimer), userInfo: nil, repeats: true)
        
        self.startTimer()
        
        let menu1 = ["image": #imageLiteral(resourceName: "home") , "title": "HOME"] as [String : Any]
        let menu2 = ["image": #imageLiteral(resourceName: "my-community-icon-active"), "title": "EXPLORE COMMUNITIES"] as [String : Any]
        let menu3 = ["image": #imageLiteral(resourceName: "speak_your_truth"), "title": "SPEAK YOUR TRUTH"] as [String : Any]
        let menu4 = ["image": #imageLiteral(resourceName: "Invite-a-friend"), "title": "INVITE A FRIEND"] as [String : Any]
        let menu5 = ["image": #imageLiteral(resourceName: "cmg"), "title": "COMMUNITY GUIDLINES"] as [String : Any]
        let menu6 = ["image": #imageLiteral(resourceName: "contact"), "title": "CONTACT US"] as [String : Any]
        let menu7 = ["image": #imageLiteral(resourceName: "FAQ"), "title": "FAQ"] as [String : Any]
        let menu8 = ["image": #imageLiteral(resourceName: "privacy_Policy"), "title": "PRIVACY POLICY"] as [String : Any]
        let menu9 = ["image": #imageLiteral(resourceName: "terms"), "title": "TERMS & CONDITIONS"] as [String : Any]
        let menu10 = ["image": #imageLiteral(resourceName: "press"), "title": "PRESS"] as [String : Any]
//        let menu10 = ["image": #imageLiteral(resourceName: "copy-link-icon"), "title": "SHARE"] as [String : Any]
        let menu11 = ["image": #imageLiteral(resourceName: "logout"), "title": "LOGOUT"] as [String : Any]
        
        self.arrMenu.append(menu1)
        self.arrMenu.append(menu2)
        self.arrMenu.append(menu3)
        self.arrMenu.append(menu4)
        self.arrMenu.append(menu5)
        self.arrMenu.append(menu6)
        self.arrMenu.append(menu7)
        self.arrMenu.append(menu8)
        self.arrMenu.append(menu9)
        self.arrMenu.append(menu10)
        self.arrMenu.append(menu11)
//        self.arrMenu.append(menu11)
        
        self.scrollViewWidth.constant = setViewWidth
        
        self.tblMenu.tableFooterView = UIView()
        self.tblMenuHeight.constant = CGFloat(self.arrMenu.count * 60)
        
    }
    
    //MARK:- Utility Methods
    
    @objc func startTimer(){
        
        let now = Date()
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, hour: 5)  // <- 5 = 5am
        let next5AM = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
        let countDown = calendar.dateComponents([.hour, .minute, .second], from: now, to: next5AM)
        
        let hours = String(format: "%02d", countDown.hour!)
        let minutes = String(format: "%02d", countDown.minute!)
        let seconds = String(format: "%02d", countDown.second!)
        
        self.lblHours.text = hours
        self.lblMinutes.text = minutes
        self.lblSeconds.text = seconds
    }
    
    //MARK:- Button Action
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView dataSource method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "cellMenu") as! MenuTableViewCell
        cellMenu.imgMenu.image = self.arrMenu[indexPath.row]["image"] as? UIImage
        cellMenu.lblMenu.text = self.arrMenu[indexPath.row]["title"] as? String
        return cellMenu
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            print("Home")
            
            AppUtility.shared.hideMenu()
            let tabbarVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
            let nav = UINavigationController(rootViewController: tabbarVC)
            nav.isNavigationBarHidden = true
            self.view.window?.rootViewController = nav
            
            
        case 1:
            print("Explore Comunities")
            
            AppUtility.shared.hideMenu()
            let exploreCommunityVC = self.storyboard?.instantiateViewController(withIdentifier: "exploreCommunityVC") as! ExploreCommunitiesViewController
            let nav = UINavigationController(rootViewController: exploreCommunityVC)
            nav.isNavigationBarHidden = true
            self.view.window?.rootViewController = nav
            
        case 2:
            print("Speak your truth")
            AppUtility.shared.hideMenu()
            
            let speakTruthVC = self.storyboard?.instantiateViewController(withIdentifier: "speakTruthVC") as! SpeakTruthViewController
            let nav = UINavigationController(rootViewController: speakTruthVC)
            nav.isNavigationBarHidden = true
            self.view.window?.rootViewController = nav
            
        case 3:
            
            print("Invite a friend")
            let inviteFriendVC = self.storyboard?.instantiateViewController(withIdentifier: "inviteFriendVC") as! InviteFriendViewController
            inviteFriendVC.modalPresentationStyle = .overFullScreen
            self.present(inviteFriendVC, animated: true, completion: nil)
            
        case 4:
        
        print("Community Guidline")
        AppUtility.shared.hideMenu()
        let communityGuidlineVC = self.storyboard?.instantiateViewController(withIdentifier: "communityGuidlineVC") as! CommunityGuidlineViewController
        navigationController?.pushViewController(communityGuidlineVC, animated: true)
            
        case 5:
            
            print("Contact")
            AppUtility.shared.hideMenu()
            let contactVC = self.storyboard?.instantiateViewController(withIdentifier: "contactVC") as! ContactViewController
            navigationController?.pushViewController(contactVC, animated: true)
            
        case 6:
            
            print("FAQ")
            AppUtility.shared.hideMenu()
            let FAQVC = self.storyboard?.instantiateViewController(withIdentifier: "FAQVC") as! FAQViewController
            navigationController?.pushViewController(FAQVC, animated: true)
            
        case 7:
            
            print("Privacy policy")
            let privacyPolicyVC = self.storyboard?.instantiateViewController(withIdentifier: "privacyPolicyVC") as! PrivacyPolicyViewController
            navigationController?.pushViewController(privacyPolicyVC, animated: true)
            
        case 8:
            
            print("Terms and Condition")
            let terms2VC = self.storyboard?.instantiateViewController(withIdentifier: "terms2VC") as! Terms2ViewController
            navigationController?.pushViewController(terms2VC, animated: true)
            
        case 9:
            
            print("Press")
            AppUtility.shared.hideMenu()
            if let url = URL(string: "https://www.geekwire.com/2019/inyore/") {
                UIApplication.shared.open(url)
            }
            
        case 10:
            
            print("Logout")
            
            self.callUserLogoutAPI()
            
//            print("Share")
//            AppUtility.shared.hideMenu()
//            let text = ""
//            let textToShare = [text]
//            let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
//            activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
//
//            activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook, UIActivity.ActivityType.saveToCameraRoll,UIActivity.ActivityType.mail,UIActivity.ActivityType.message ]
//            self.present(activityViewController, animated: true, completion: nil)
            
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: API Methods
    
    func callUserLogoutAPI(){
        
        if AppUtility.shared.connected() == false{
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("no_network_alert_title", comment: ""), messageText: NSLocalizedString("no_network_alert_description", comment: ""), delegate: self)
            return
        }
        
        APIHandler.sharedInstance.userLogout { (isSuccess, response) in
            print(response)
            if isSuccess == true{
                
                if response!["code"] as! Int == 200{
                    
                    self.myUser = User.readUserFromArchive()
                    self.myUser?.remove(at: 0)
                    if User.saveUserToArchive(user: self.myUser!){
                        
                        _ = HTTPCookie.self
                        let cookieJar = HTTPCookieStorage.shared
                        
                        for cookie in cookieJar.cookies! {
                            cookieJar.deleteCookie(cookie)
                        }
                        
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let loginVC = storyBoard.instantiateViewController(withIdentifier:"loginVC")as! LoginViewController
                        let nav = UINavigationController(rootViewController: loginVC)
                        nav.navigationBar.isHidden = true
                        self.view.window?.rootViewController = nav
                    }

                }
                else{
                    
                    let msg = response!["msg"] as! String
                    AppUtility.shared.displayAlert(title: NSLocalizedString("alert_error_title", comment: ""), messageText: msg, delegate: self)
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

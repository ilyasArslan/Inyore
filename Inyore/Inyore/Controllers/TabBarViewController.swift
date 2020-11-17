//
//  TabBarViewController.swift
//  Inyore
//
//  Created by Arslan on 29/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = 1
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.openNotification(notification:)), name: Notification.Name("openNotification"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.setBadgeCount), name: Notification.Name("setBadge"), object: nil)
    }
    
//    @objc func openNotification(notification: Notification) {
//        
//        self.selectedIndex = 0
//    }
    
    @objc func setBadgeCount(notification: Notification){
        
        let badge = notification.userInfo?["badge"] as! Int
        print("Badge: ", badge)
        self.tabBar.items![0].badgeValue = "\(badge)"
    }
    
}

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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("openNotification"), object: nil)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        self.selectedIndex = 0
    }

}

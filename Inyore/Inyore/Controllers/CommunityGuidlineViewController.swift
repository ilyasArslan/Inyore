//
//  CommunityGuidlineViewController.swift
//  Inyore
//
//  Created by Arslan on 05/11/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class CommunityGuidlineViewController: UIViewController {
    
    //MARK: Outlets
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
}

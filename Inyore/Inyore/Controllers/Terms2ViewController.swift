//
//  Terms2ViewController.swift
//  Inyore
//
//  Created by Arslan on 20/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class Terms2ViewController: UIViewController {

    //MARK: Outlets
        
    @IBOutlet weak var btnBack: UIButton!

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

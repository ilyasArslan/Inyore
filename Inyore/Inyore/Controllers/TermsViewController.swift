//
//  TermsViewController.swift
//  Inyore
//
//  Created by Arslan on 10/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    

    //MARK: Outlets
        
    @IBOutlet weak var termsCV: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.termsCV.layer.cornerRadius = 10
        
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    @IBAction func btnSkipAction(_ sender: UIButton) {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
        tabbarVC.modalPresentationStyle = .fullScreen
        self.present(tabbarVC, animated: true, completion: nil)
    }
    
    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 0{
            
            let cellTerms = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTerms", for: indexPath) as! TermsCollectionViewCell
            cellTerms.btnContinue.tag = indexPath.item
            cellTerms.btnContinue.addTarget(self, action: #selector(self.btnNextAction(btn:)), for: .touchUpInside)
            
//            self.pageControl.currentPage = indexPath.item
            
            return cellTerms
        }
        else if indexPath.item == 1{
            
            let cellTerms2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTerms2", for: indexPath) as! TermsCollectionViewCell
            
            cellTerms2.lblText.isHidden = true
            cellTerms2.lblDescTopConstraint.constant = 8
            cellTerms2.lblDesc.text = "A platform that gives employees a safe and secure space to share, learn, engage, and interact with one another on sensitive topics without the fear of retaliation, judgment or feeling excluded."
            
            cellTerms2.btnContinue.setTitle("Continue", for: .normal)
            cellTerms2.btnContinue.tag = indexPath.item
            cellTerms2.btnContinue.addTarget(self, action: #selector(self.btnNextAction(btn:)), for: .touchUpInside)
                        
            return cellTerms2
        }
        else{
            
            let cellTerms2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cellTerms2", for: indexPath) as! TermsCollectionViewCell
            
            cellTerms2.lblText.isHidden = false
            cellTerms2.lblDescTopConstraint.constant = 37
            cellTerms2.lblText.text = "You are NOT alone"
            cellTerms2.lblDesc.text = "Inyore has content you will be able to learn and feel great about reading. Inyore helps you understand that other professionals are living through the same conditions enabling you to share experiences."
            
            cellTerms2.btnContinue.setTitle("Let's Start", for: .normal)
            cellTerms2.btnContinue.tag = indexPath.item
            cellTerms2.btnContinue.addTarget(self, action: #selector(self.btnNextAction(btn:)), for: .touchUpInside)
                        
            return cellTerms2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.termsCV.bounds.width / 1
        return CGSize(width: width, height: 330)
    }
    
    //MARK:- button Next Action
    @objc func btnNextAction(btn: UIButton){
        
        if btn.tag == 0{
            
            let index = IndexPath(item: btn.tag + 1, section: 0)
            self.pageControl.currentPage = btn.tag + 1
            termsCV.scrollToItem(at: index, at: .left, animated: true)
        }
        else if btn.tag == 1{
                        
            let index = IndexPath(item: btn.tag + 1, section: 0)
            self.pageControl.currentPage = btn.tag + 1
            termsCV.scrollToItem(at: index, at: .left, animated: true)
        }
        else{
                        
            UserDefaults.standard.set("1", forKey: "userAgreeTerms")
            
            let story = UIStoryboard(name: "Main", bundle: nil)
            let tabbarVC = story.instantiateViewController(withIdentifier: "tabbarVC") as! TabBarViewController
            tabbarVC.modalPresentationStyle = .fullScreen
            self.present(tabbarVC, animated: true, completion: nil)
        }
    }
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
}

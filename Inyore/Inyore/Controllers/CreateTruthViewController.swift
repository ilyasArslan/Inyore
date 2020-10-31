
//  CreateTruthViewController.swift
//  Inyore
//
//  Created by Arslan on 03/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class CreateTruthViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Outlets
    @IBOutlet weak var txtTitle: CustomTextField!
    @IBOutlet weak var lblTitleTextCount: UILabel!
    @IBOutlet weak var txtMoreInfo: CustomTextView!
    @IBOutlet weak var lblMoreInfoTextCount: UILabel!
    
    @IBOutlet weak var imageTruth: UIImageView!
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    var isPicked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        self.imagePicker.delegate = self
        
        self.txtTitle.delegate = self
        self.txtMoreInfo.delegate = self
        
        self.txtTitle.addTarget(self, action: #selector(self.chnageText(textField:)), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK:- Utility Methods
    
    //MARK:- Button Action
    
    @IBAction func btnMenuAction(_ sender: UIButton) {
        
        AppUtility.shared.showMenu(controller: self)
    }
    
    @IBAction func btnAddBannerAction(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .fullScreen
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:- ImagePicker delegate methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            self.isPicked = true
            self.image = pickedImage
            self.imageTruth.image = image
            self.dismiss(animated: true, completion: nil)
            
        }
        else
        {
            print("Error in pick Image")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        
        print("Cnacel Image")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnNextAction(_ sender: UIButton) {
        
        if AppUtility.shared.isEmpty(self.txtTitle.text!){
            
            AppUtility.shared.displayAlert(title: NSLocalizedString("alert_app_name", comment: ""), messageText: NSLocalizedString("validation_empty_title", comment: ""), delegate: self)
            return
        }
        
        if self.isPicked == false{
            
            let createTruthScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "createTruthScreenVC") as! CreateTruthScreenViewController
            
            createTruthScreenVC.isPicked = false
            createTruthScreenVC.article_title = self.txtTitle.text!
            createTruthScreenVC.article_description = self.txtMoreInfo.text!
            
            navigationController?.pushViewController(createTruthScreenVC, animated: true)
        }
        
        else{
            
            let createTruthScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "createTruthScreenVC") as! CreateTruthScreenViewController
            
            createTruthScreenVC.isPicked = true
            createTruthScreenVC.article_title = self.txtTitle.text!
            createTruthScreenVC.article_description = self.txtMoreInfo.text!
            createTruthScreenVC.community_banner_image = self.image
            
            navigationController?.pushViewController(createTruthScreenVC, animated: true)
        }
        
    }
    //MARK: API Methods
    
    //MARK:- DELEGATE METHODS
    
    //MARK: TableView
    
    //MARK: CollectionView
    
    //MARK: Segment Control
    
    //MARK: Alert View
    
    //MARK: TextField
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        if let text = self.txtTitle.text{
            
            let count = text.count + string.count - range.length
            return count <= 40
        }
            
        else { return true }

    }
    
    @objc func chnageText(textField: UITextField){
        
        self.lblTitleTextCount.text = "\(self.txtTitle.text!.count)/40"
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return textView.text.count + (text.count - range.length) <= 1000
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.lblMoreInfoTextCount.text = "\(self.txtMoreInfo.text!.count)/1000"
    }

}

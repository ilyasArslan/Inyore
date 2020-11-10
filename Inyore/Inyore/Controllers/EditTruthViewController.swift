//
//  EditTruthViewController.swift
//  Inyore
//
//  Created by Arslan on 04/11/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class EditTruthViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //MARK: Outlets
    @IBOutlet weak var txtTitle: CustomTextField!
    @IBOutlet weak var lblTitleTextCount: UILabel!
    @IBOutlet weak var txtMoreInfo: CustomTextView!
    @IBOutlet weak var lblMoreInfoTextCount: UILabel!
    
    @IBOutlet weak var imageTruth: UIImageView!
    
    var image = UIImage()
    let imagePicker = UIImagePickerController()
    var isPicked = false
    
    var dict = [String : Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    //MARK:- Setup View
    func setupView() {
        
        
        self.txtTitle.text = self.dict["ar_title"] as? String
        self.txtMoreInfo.text = self.dict["ar_description"] as? String
        let imageUrl = "https://www.inyore.com/chatsystem/public/uploadFiles/article_header/\(self.dict["ar_image_link"] as? String ?? "")"
        self.imageTruth.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "image_placeholder"))
        
        self.imagePicker.delegate = self
        
        self.txtTitle.delegate = self
        self.txtMoreInfo.delegate = self
        
        self.txtTitle.addTarget(self, action: #selector(self.chnageText(textField:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("clearData"), object: nil)
    }
    
    //MARK:- Utility Methods
    @objc func methodOfReceivedNotification(notification: Notification){
        
        self.txtTitle.text = ""
        self.txtMoreInfo.text = ""
        self.isPicked = false
        self.imageTruth.image = nil
        self.imageTruth.image = #imageLiteral(resourceName: "image_placeholder")
    }
    
    //MARK:- Button Action
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
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
            
            let editTruthScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "editTruthScreenVC") as! EditTruthScreenViewController
            
            editTruthScreenVC.isPicked = false
            editTruthScreenVC.article_id = "\(self.dict["id"] as! Int)"
            editTruthScreenVC.article_title = self.txtTitle.text!
            editTruthScreenVC.article_description = self.txtMoreInfo.text!
            
            navigationController?.pushViewController(editTruthScreenVC, animated: true)
        }
        
        else{
            
            let editTruthScreenVC = self.storyboard?.instantiateViewController(withIdentifier: "editTruthScreenVC") as! EditTruthScreenViewController
            
            editTruthScreenVC.isPicked = true
            editTruthScreenVC.article_id = "\(self.dict["id"] as! Int)"
            editTruthScreenVC.article_title = self.txtTitle.text!
            editTruthScreenVC.article_description = self.txtMoreInfo.text!
            editTruthScreenVC.community_banner_image = self.image
            
            navigationController?.pushViewController(editTruthScreenVC, animated: true)
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

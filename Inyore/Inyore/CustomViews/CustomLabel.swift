//
//  CustomLabel.swift
//  PrayerPop
//
//  Created by Azeem Akram on 18/09/2018.
//  Copyright © 2018 AzeemAkram. All rights reserved.
//

import UIKit

@IBDesignable class CustomLabel: UILabel {
    
    
    
    @IBInspectable var cornarRadius:CGFloat = 0.0 {
        
        didSet {
            layer.cornerRadius = cornarRadius
        }
        
    }
    
    @IBInspectable var isCircle:Bool = false {
        
        didSet {
            if isCircle {
                layer.cornerRadius  = self.frame.size.width/2
            }else{
                layer.cornerRadius = cornarRadius
            }
        }
        
    }
    
    @IBInspectable var borderWidth:CGFloat = 0.0 {
        
        didSet {
            layer.borderWidth = borderWidth
            layer.borderColor = borderColor.cgColor
        }
        
    }
    
    @IBInspectable var borderColor:UIColor = UIColor.lightGray {
        
        didSet {
            layer.borderColor = borderColor.cgColor
            if borderWidth == 0 {borderWidth = 1.0}
        }
    }
    
    @IBInspectable var shadowColor1: UIColor = UIColor.clear {
        
        didSet {
            layer.shadowColor = shadowColor1.cgColor
        }
    }
    
    @IBInspectable var shadowOffset1: CGSize = CGSize.zero {
        
        didSet {
            layer.shadowOffset = shadowOffset1
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 5.0 {
        
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    
    @IBInspectable var isUnderLine: Bool = false {
        
        didSet {
            guard let text      = text else { return }
            let textRange       = NSMakeRange(0, text.count)
            let attributedText  = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            self.attributedText = attributedText
        }
    }
    
   
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if isCircle {
            layer.cornerRadius  = self.frame.size.width/2
        }else{
            layer.cornerRadius = cornarRadius
        }
    }
}

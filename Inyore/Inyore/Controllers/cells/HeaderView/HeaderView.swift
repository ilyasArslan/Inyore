//
//  HeaderView.swift
//  Inyore
//
//  Created by Arslan on 30/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ActiveLabel

final class HeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = String(describing: self)

    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblComment: ActiveLabel!
    
    @IBOutlet weak var btnPraise: CustomButton!
    @IBOutlet weak var btnLike: CustomButton!
    @IBOutlet weak var btnDisappoint: CustomButton!
    
    @IBOutlet weak var lblCommentBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnDidPraise: CustomButton!
    @IBOutlet weak var btnDidHeart: CustomButton!
    @IBOutlet weak var btnDidDisappoint: CustomButton!
    
    @IBOutlet weak var btnReply: CustomButton!
    @IBOutlet weak var btnReport: CustomButton!
    @IBOutlet weak var btnMoreMenu: CustomButton!
    
}

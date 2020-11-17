//
//  ReplyTableViewCell.swift
//  Inyore
//
//  Created by Arslan on 24/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ActiveLabel

class ReplyTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblReply: ActiveLabel!
    
    @IBOutlet weak var btnPraise: CustomButton!
    @IBOutlet weak var btnLike: CustomButton!
    @IBOutlet weak var btnDisAppoint: CustomButton!
    
    @IBOutlet weak var lblReplyBottom: NSLayoutConstraint!
    
    @IBOutlet weak var btnDidPraise: CustomButton!
    @IBOutlet weak var btnDidHeart: CustomButton!
    @IBOutlet weak var btnDidDisappoint: CustomButton!
    @IBOutlet weak var btnReply: CustomButton!
    @IBOutlet weak var btnReport: CustomButton!
    @IBOutlet weak var btnMore: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

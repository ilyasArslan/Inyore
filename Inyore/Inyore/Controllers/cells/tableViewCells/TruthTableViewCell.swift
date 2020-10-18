//
//  TruthTableViewCell.swift
//  Inyore
//
//  Created by Arslan on 29/09/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class TruthTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCommunityTitle: UILabel!
    @IBOutlet weak var ar_image_link: CustomImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    @IBOutlet weak var btnComment: CustomButton!
    @IBOutlet weak var btnPraise: CustomButton!
    @IBOutlet weak var btnShare: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

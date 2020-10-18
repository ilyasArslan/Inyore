//
//  SingleCommunityTableViewCell.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class SingleCommunityTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCommunity: CustomImageView!
    @IBOutlet weak var lblCommunityTitle: UILabel!
    @IBOutlet weak var lblArticleTitle: UILabel!
    @IBOutlet weak var lblArticleTime: UILabel!
    @IBOutlet weak var lblArticleDescription: UILabel!
    
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

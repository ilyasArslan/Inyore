//
//  MyCommunitiyTableViewCell.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit
import ActiveLabel

class MyCommunitiyTableViewCell: UITableViewCell {

    @IBOutlet weak var imgCommunity: CustomImageView!
    @IBOutlet weak var lblCommunityTitle: UILabel!
    @IBOutlet weak var lblCommunityMember: UILabel!
    @IBOutlet weak var lblCommunityDesc: ActiveLabel!
    
    @IBOutlet weak var btnFolllowing: CustomButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

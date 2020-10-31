//
//  NotificationTableViewCell.swift
//  Inyore
//
//  Created by Arslan on 05/10/2020.
//  Copyright © 2020 Arslan. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var imgNotification: CustomImageView!
    @IBOutlet weak var lblNotificationTitle: UILabel!
    @IBOutlet weak var lblNotificationMessage: UILabel!
    @IBOutlet weak var lblNotificationTime: UILabel!
    
    @IBOutlet weak var isReadView: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

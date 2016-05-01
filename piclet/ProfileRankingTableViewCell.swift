//
//  ProfileRankingTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/05/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileRankingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2.0
        avatarImageView.layer.masksToBounds = true
    }
}

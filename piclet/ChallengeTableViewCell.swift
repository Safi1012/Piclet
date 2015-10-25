//
//  ChallengeTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 12/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var timepostedLabel: UILabel!
    @IBOutlet weak var numberPostsLabel: UILabel!
    @IBOutlet weak var numberLikesLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

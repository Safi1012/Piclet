//
//  ChallengeTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 12/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timePostedLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stylePreviewImage()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func stylePreviewImage() {
        previewImageView.layer.cornerRadius = 5.0
        previewImageView.layer.masksToBounds = true
    }
    
}

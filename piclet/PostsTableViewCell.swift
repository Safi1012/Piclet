//
//  PostsTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    var post: Post!
    var delegate: PostsTableViewDelegate?
    
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postVotesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    weak var postTableViewController: PostsTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addDoubleTapGestureRecognizer(postTableViewController: PostsTableViewController) {
        self.postTableViewController = postTableViewController
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "detectedDoubleTap")
            doubleTapRecognizer.numberOfTapsRequired = 2
        
        postImage.userInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func detectedDoubleTap() {
        userPressedLikeButton()
    }
    
    @IBAction func userPressedLikeButton() {
        delegate?.likeButtonInCellWasPressed(self, post: post)
    }
}

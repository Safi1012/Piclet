//
//  PostsTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class PostsTableViewCell: UITableViewCell {

    var post: Post!
    var delegate: PostsTableViewDelegate?
    
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postVotesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postLikeButton: UIButton!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    weak var postViewController: PostsViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addDoubleTapGestureRecognizer(postViewController: PostsViewController) {
        self.postViewController = postViewController
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostsTableViewCell.detectedDoubleTap))
            doubleTapRecognizer.numberOfTapsRequired = 2
        
        postImage.userInteractionEnabled = true
        postImage.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func detectedDoubleTap() {
        userPressedLikeButton()
    }
    
    
    // MARK: - UI
    
    @IBAction func userPressedLikeButton() {
        delegate?.likeButtonInCellWasPressed(self, post: post)
    }
}

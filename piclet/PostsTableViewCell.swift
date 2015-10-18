//
//  PostsTableViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    var postID: String?
    
    @IBOutlet weak var postDescriptionLabel: UILabel!
    @IBOutlet weak var postVotesLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postUsernameLabel: UILabel!
    @IBOutlet weak var postLikeImage: UIImageView!
    @IBOutlet weak var postTimeLabel: UILabel!
    
    // weak var postTableViewController: PostsTableViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        // postTableViewController.view.addGestureRecognizer(doubleTapRecognizer)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
//    func addDoubleTapGestureRecognizer(postTableViewController: PostsTableViewController) {
//        
//        self.postTableViewController = postTableViewController
//        
//        let doubleTapRecognizer = UITapGestureRecognizer(target: postImage, action: "detectedDoubleTap")
//        doubleTapRecognizer.numberOfTapsRequired = 2
//        
//        self.addGestureRecognizer(doubleTapRecognizer)
//    }

    func detectedDoubleTap() {
        

        
        print("Tapped twice")
    }
    
}

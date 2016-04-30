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
    
    internal var aspectConstraint : NSLayoutConstraint? {
        didSet {
            if oldValue != nil {
                postImage.removeConstraint(oldValue!)
            }
            if aspectConstraint != nil {
                postImage.addConstraint(aspectConstraint!)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        aspectConstraint = nil
    }
    
    func setImageUrl(url: NSURL) {
        let manager = SDWebImageManager.sharedManager()
        
        manager.downloadImageWithURL(url, options: SDWebImageOptions.ProgressiveDownload, progress: { (a, b) in
            print("a: \(a)")
            print("b: \(b)")
        
        }) { (image, error, chache, completed, url) in
            self.setPostedImage(image)
                
        }
    }
    
    func setPostedImage(image : UIImage) {
        let aspect = image.size.width / image.size.height
        print(image.size.width)
        print(image.size.height)
        
        aspectConstraint = NSLayoutConstraint(item: postImage, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: postImage, attribute: NSLayoutAttribute.Height, multiplier: aspect, constant: 0.0)
        
        postImage.image = image
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

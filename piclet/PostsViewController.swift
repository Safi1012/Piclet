//
//  PostsViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 23/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class PostsViewController: UIViewController {
    
    @IBOutlet weak var mascotView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var challenge: Challenge!
    var posts = [Post]()
    var isRequesting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        refreshPosts()
    }

    
    // MARK: - UI
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func setButtonImage(button: UIButton, imageName: String) {
        dispatch_async(dispatch_get_main_queue(), {
            button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        })
    }
    
    @IBAction func userPressedMascot(sender: UIButton) {
        userPressedCreatePost()
    }
    
    @IBAction func pressedCreatePost(sender: UIBarButtonItem) {
        userPressedCreatePost()
    }
    
    func displayMascotView() {
        self.tableView.hidden = true
        self.mascotView.hidden = false
    }
    
    func displayTableView() {
        self.tableView.hidden = false
        self.mascotView.hidden = true
    }
    

    // MARK: - Posts
    
    func refreshPosts() {
        
        ApiProxy().fetchChallengePosts(challenge.id, success: { (posts) -> () in
            self.posts = posts
            
            if self.posts.count > 0 {
                self.displayTableView()
                self.tableView.performSelectorOnMainThread(Selector("reloadData"), withObject: nil, waitUntilDone: true)
            } else {
                self.displayMascotView()
            }
        
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
                
        }
    }
    
    func likeChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().likePost(token, challengeID: challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
        }) { (errorCode) -> () in
            post.votes!--
            cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = (post.votes > 1 || post.votes == 0) ? "\(post.votes) Votes" : "\(post.votes) Vote"
            self.displayAlert(errorCode)
            self.isRequesting = false
                
        }
    }
    
    func revertChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().revertLikePost(token, challengeID: challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
        }) { (errorCode) -> () in
            post.votes!++
            cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = (post.votes > 1 || post.votes == 0) ? "\(post.votes) Votes" : "\(post.votes) Vote"
            self.displayAlert(errorCode)
            self.isRequesting = false
                
        }
    }
    
    func userPressedCreatePost() {
        if let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            if loggedInUser.token != nil {
                
                displayTableView()
                performSegueWithIdentifier("toImagePickerViewController", sender: self)
                return
            }
        }
        self.displayAlert("NotLoggedIn")
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toImagePickerViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! ImagePickerViewController
            destinationVC.token = User.getLoggedInUser(AppDelegate().managedObjectContext)!.token!
            destinationVC.challengeID = challenge.id
        }
    }
    
    @IBAction func unwindToPostTableViewController(segue: UIStoryboardSegue) {}
}


// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell

        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = posts[indexPath.row].votes > 1 || posts[indexPath.row].votes == 0 ? "\(posts[indexPath.row].votes) Votes" : "\(posts[indexPath.row].votes) Vote"
        
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = TimeHandler().getPostedTimestampFormated(posts[indexPath.row].posted)
        
        let url = "https://flash1293.de/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        cell.postImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "challengePreviewPlaceholder"))
        
        if let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            for username in posts[indexPath.row].voters {
                if username == loggedInUser.username {
                    cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                    break
                }
            }
        }
        return cell
    }
}


// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let imageView = UIImageView()
        let url = "https://flash1293.de/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "challengePreviewPlaceholder"))
        
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageView.image
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
        imageViewer.optionsDelegate = self
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOffscreen)
    }
}


// MARK: - PostsTableViewDelegate

extension PostsViewController: PostsTableViewDelegate {
    
    func likeButtonInCellWasPressed(cell: PostsTableViewCell, post: Post) {
        
        guard
            let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext),
            let token = loggedInUser.token
        else {
            self.displayAlert("NotLoggedIn")
            return
        }
        if isRequesting {
            return
        }
        isRequesting = true
        
        if cell.postLikeButton.imageForState(UIControlState.Normal) == UIImage(named: "likeFilled") {
            cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
            post.votes!--
            cell.postVotesLabel.text = "\(post.votes) Votes"
            
            revertChallengePost(post, cell: cell, token: token)
        } else {
            cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
            post.votes!++
            cell.postVotesLabel.text = "\(post.votes) Votes"
            
            likeChallengePost(post, cell: cell, token: token)
        }
    }
}


// MARK: - JTSImageViewControllerOptionsDelegate

extension PostsViewController: JTSImageViewControllerOptionsDelegate {
    
    func backgroundColorImageViewInImageViewer(imageViewer: JTSImageViewController) -> UIColor {
        return UIColor.blackColor()
    }
    
    func alphaForBackgroundDimmingOverlayInImageViewer(imageViewer: JTSImageViewController) -> CGFloat {
        return 1.0
    }
}

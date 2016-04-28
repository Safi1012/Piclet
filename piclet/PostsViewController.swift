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
    private var isRequesting = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = challenge.title
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // tableView.setNeedsLayout()
        // tableView.layoutIfNeeded()
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
        
        if !checkIfUserAlreadyPosted() {
            userPressedCreatePost()
        } else {
            displayAlert("AlreadyPostedError")
        }
    }
    
    func displayMascotView() {
        tableView.hidden = true
        mascotView.hidden = false
    }
    
    func displayTableView() {
        tableView.hidden = false
        mascotView.hidden = true
    }
    

    // MARK: - Posts
    
    func refreshPosts() {
        
        ApiProxy().fetchChallengePosts(challenge.id, success: { (posts) -> () in
            self.posts = posts
            
            if self.posts.count > 0 {
                self.displayTableView()
                self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
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
            post.votes! -= 1
            cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "Vote")
            self.isRequesting = false
            self.displayAlert(errorCode)
            
        }
    }
    
    func revertChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().revertLikePost(token, challengeID: challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
        }) { (errorCode) -> () in
            post.votes! += 1
            cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "Vote")
            self.isRequesting = false
            self.displayAlert(errorCode)
            
        }
    }
    
    func userPressedCreatePost() {

        if UserAccess.sharedInstance.isUserLoggedIn() {
            displayTableView()
            performSegueWithIdentifier("toImagePickerViewController", sender: self)
            
        } else {
            self.displayAlert("NotLoggedIn")
            
        }
    }
    
    func checkIfUserAlreadyPosted() -> Bool {
        
        if let user = UserAccess.sharedInstance.getUser() {
            for post in posts {
                if post.creator == user.username {
                    return true
                }
            }
        }
        return false
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toImagePickerViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! ImagePickerViewController
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
        let url = "https://flash1293.de/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"

        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = Formater().formatSingularAndPlural(posts[indexPath.row].votes, singularWord: "Vote")
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = TimeHandler().getPostedTimestampFormated(posts[indexPath.row].posted)
        
        UIImageView().sd_setImageWithURL(NSURL(string: url)) { (image, error, cache, url) in
            cell.setPostedImage(image)
        }
        
        if let user = UserAccess.sharedInstance.getUser() {
            for username in posts[indexPath.row].voters {
                if username == user.username {
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
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "grayPlaceholder"))
        
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
        
        if let user = UserAccess.sharedInstance.getUser() {
            if isRequesting {
                return
            }
            isRequesting = true
            
            if cell.postLikeButton.imageForState(UIControlState.Normal) == UIImage(named: "likeFilled") {
                post.votes! -= 1
                cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
                revertChallengePost(post, cell: cell, token: user.token)
                
            } else {
                post.votes! += 1
                cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                likeChallengePost(post, cell: cell, token: user.token)
                
            }
            
            // check if neccesary
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "Vote")
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

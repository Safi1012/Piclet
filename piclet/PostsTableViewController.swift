//
//  PostsTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class PostsTableViewController: UITableViewController {
    
    var challenge: Challenge!
    var posts = [Post]()
    var isRequesting = false
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPosts()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = challenge!.title
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

    @IBAction func pressedCreatePost(sender: UIBarButtonItem) {
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            if loggedInUser.token != nil {
                performSegueWithIdentifier("toImagePickerViewController", sender: self)
                return
            }
        }
        self.displayAlert("NotLoggedIn")
    }
    
    
    // MARK: - Posts
    
    func refreshPosts() {
        
        ApiProxy().getChallengesPosts(challenge.id, success: { (posts) -> () in
            self.posts = posts
            
            ImageHandler().loadImagePosts(self.posts, challengeID: self.challenge.id, imagesize: ImageSize.medium, imageFormat: ImageFormat.webp, complete: { () -> () in
                // self.reloadTableView()
                
                self.tableView.performSelectorOnMainThread(Selector("reloadData"), withObject: nil, waitUntilDone: true)
            })
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func likeChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().likeChallengePost(token, challengeID: challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
            }, failed: { (errorCode) -> () in
                post.votes!--
                cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                cell.postVotesLabel.text = "\(post.votes) Votes"
                
                self.displayAlert(errorCode)
                self.isRequesting = false
                
        })
    }
    
    func revertChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().revertLikeChallengePost(token, challengeID: challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
            }) { (errorCode) -> () in
                post.votes!++
                cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
                cell.postVotesLabel.text = "\(post.votes) Votes"
                
                self.displayAlert(errorCode)
                self.isRequesting = false
                
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toImagePickerViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! ImagePickerViewController
            destinationVC.token = User.getLoggedInUser(managedObjectContext)!.token!
            destinationVC.challengeID = challenge.id
        }
    }
    
    @IBAction func unwindToPostTableViewController(segue: UIStoryboardSegue) {
        print("BACK again")
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        
        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = posts[indexPath.row].votes > 1 ? "\(posts[indexPath.row].votes) Votes" : "\(posts[indexPath.row].votes) Vote"
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = TimeHandler().getPostedTimestampFormated(posts[indexPath.row].posted)
        
        let url = "https://flash1293.de/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        cell.postImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "challengePreviewPlaceholder"))
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
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


// MARK: - PostsTableViewDelegate

extension PostsTableViewController: PostsTableViewDelegate {
    
    func likeButtonInCellWasPressed(cell: PostsTableViewCell, post: Post) {
        
        guard
            let loggedInUser = User.getLoggedInUser(managedObjectContext),
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

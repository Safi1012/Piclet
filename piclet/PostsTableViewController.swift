//
//  PostsTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

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
        // refreshPosts()
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


    
    // MARK: - Posts
    
    func refreshPosts() {
        
        ApiProxy().getChallengesPosts(challenge.id, success: { (posts) -> () in
            
            self.posts = posts
            
            if !self.checkIfThumbnailsExists() {
                self.getThumbnailsOfChallenge()
            }
            self.reloadTableView()
            self.isRequesting = false
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(errorCode)
            self.isRequesting = false
        }
    }
    
    func getThumbnailsOfChallenge() {
        
        for post in posts {
            
            ApiProxy().getPostImageInSize(challenge.id, postID: post.id, imageSize: ImageSize.medium, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }, failed: { (errorCode) -> () in
                self.displayAlert(errorCode)
            })
        }
    }

    func checkIfThumbnailsExists() -> Bool {
        
        for post in posts {
            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_medium" + ".webp")
            
            if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                // return true
            }
        }
        return false
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
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let imagePath = documentPath.stringByAppendingPathComponent(posts[indexPath.row].id + "_medium" + ".webp")
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        cell.post = posts[indexPath.row]
        
        cell.delegate = self
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = posts[indexPath.row].votes > 1 ? "\(posts[indexPath.row].votes) Votes" : "\(posts[indexPath.row].votes) Vote"
        cell.postImage.image = UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath))
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = TimeHandler().getPostedTimestampFormated(posts[indexPath.row].posted)
        
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

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
        refreshPosts()
    }
    
    

    // MARK: - UI
    
    func showLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            let loadingSpinner = MBProgressHUD.showHUDAddedTo(self.tableView.superview, animated: true)
            loadingSpinner.labelText = "Loading Data"
        })
    }
    
    func hideLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.tableView.superview, animated: true)
        })
    }
    
    func displayAlert(alertController: UIAlertController) {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func userPressedLikeButton(post: Post, likeButton: UIButton) {
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            
            if !isRequesting {
                isRequesting = true
                
                if likeButton.imageForState(UIControlState.Normal) == UIImage(named: "likeFilled") {
                    
                    ApiProxy().revertLikeChallengePost(loggedInUser.token, challengeID: challenge!.id!, postID: post.id!, success: { () -> () in
                        self.refreshPosts()
                        self.isRequesting = false
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            likeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
                        })
                        
                    }, failed: { (errorCode) -> () in
                        self.displayLikeFailedError(errorCode, loggedInUser: loggedInUser)
                        self.isRequesting = false
                    })
                } else {
                    
                    ApiProxy().likeChallengePost(loggedInUser.token, challengeID: challenge!.id!, postID: post.id!, success: { () -> () in
                        self.refreshPosts()
                        self.isRequesting = false
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            likeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                        })
                        
                    }, failed: { (errorCode) -> () in
                        self.displayLikeFailedError(errorCode, loggedInUser: loggedInUser)
                        self.isRequesting = false
                    })
                }
            }
        } else {
            self.displayAlert(UIAlertController.createAlertWithLoginSegue("NotLoggedIn", viewController: self))
        }
    }

    func displayLikeFailedError(errorCode: String, loggedInUser: User) {
        if errorCode == "UnauthorizedError" {
            self.displayAlert(UIAlertController.createAlertWithLoginSegue(errorCode, viewController: self))
            User.updateUserToken(self.managedObjectContext, user: loggedInUser, newToken: nil) // only when user changed password -> session is invalid, Untested !!
        } else {
            self.displayAlert(UIAlertController.createErrorAlert(errorCode))
        }
    }
    
    
    
    // MARK: - Posts
    
    func refreshPosts() {
        // showLoadingSpinner()
        
        ApiProxy().getChallengesPosts(challenge!.id, success: { (posts) -> () in
            
            // self.hideLoadingSpinner()
            
            self.posts = posts
            
            if !self.checkIfThumbnailsExists() {
                self.getThumbnailsOfChallenge()
            }
            self.reloadTableView()
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(UIAlertController.createErrorAlert(errorCode))
        }
    }
    
    func getThumbnailsOfChallenge() {
        
        for post in posts {
            
            ApiProxy().getPostImageInSize(nil, challengeID: challenge!.id, postID: post.id, imageSize: ImageSize.medium, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }) { (errorCode) -> () in
                self.displayAlert(UIAlertController.createErrorAlert(errorCode))
            }
        }
    }

    func checkIfThumbnailsExists() -> Bool {
        
        for post in posts {
            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_medium" + ".webp")
            
            if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                return true
            }
        }
        return false
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

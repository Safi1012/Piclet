//
//  PostsTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    var challengeID: String?
    var posts = [Post]()
    
    
    var challenge: Challenge?
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshPosts()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
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
    
    func createNotLoggedInAlert() -> UIAlertController {
        let alertContoller = ErrorHandler().createErrorAlert("NotLoggedIn")
        alertContoller.addAction(UIAlertAction(title: "Login / Create Account", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            dispatch_async(dispatch_get_main_queue()) {
                if (UIApplication.sharedApplication().delegate as! AppDelegate).loginViewController != nil {
                    self.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                    self.presentViewController(loginVC, animated: true, completion: nil)
                }
            }
        }))
        return alertContoller
    }
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func userPressedLikeButton(post: Post, likeButton: UIButton) {
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            
            if likeButton.imageForState(UIControlState.Normal) == UIImage(named: "likeFilled") {
                likeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
                
                ApiProxy().revertLikeChallengePost(loggedInUser.token, challengeID: challengeID!, postID: post.id!, success: { () -> () in
                    self.refreshPosts()
                }, failed: { (errorCode) -> () in
                    self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
                })
            } else {
                likeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                
                ApiProxy().likeChallengePost(loggedInUser.token, challengeID: challengeID!, postID: post.id!, success: { () -> () in
                    self.refreshPosts()
                }, failed: { (errorCode) -> () in
                    self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
                })
            }
        } else {
            displayAlert(createNotLoggedInAlert())
        }
    }


    
    
    
    // MARK: - Posts
    
    func refreshPosts() {
        // showLoadingSpinner()
        
        ApiProxy().getChallengesPosts(challengeID!, success: { (posts) -> () in
            
            // self.hideLoadingSpinner()
            
            self.posts = posts
            
            if !self.checkIfThumbnailsExists() {
                self.getThumbnailsOfChallenge()
            }
            self.reloadTableView()
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
        }
    }
    
    func getThumbnailsOfChallenge() {
        
        for post in posts {
            
            ApiProxy().getPostImageInSize(nil, challengeID: challengeID!, postID: post.id!, imageSize: ImageSize.medium, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }) { (errorCode) -> () in
                self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
            }
        }
    }

    func checkIfThumbnailsExists() -> Bool {
        
        for post in posts {
            let imagePath = documentPath.stringByAppendingPathComponent(post.id! + "_medium" + ".webp")
            
            if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                return true
            }
        }
        return false
    }
    
    func getPostedTimeFormated(datePosted: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar().components([NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: datePosted, toDate: NSDate(), options: [])
        
        if calendar.day != 0 {
            return "\(calendar.day)d"
        }
        if calendar.hour > 0 {
            return "\(calendar.hour)h"
        }
        if calendar.minute > 0 {
            return "\(calendar.minute)h"
        }
        return "\(calendar.second)s"
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let imagePath = documentPath.stringByAppendingPathComponent(posts[indexPath.row].id! + "_medium" + ".webp")
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        cell.post = posts[indexPath.row]
        
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = posts[indexPath.row].votes! > 1 ? "\(posts[indexPath.row].votes!) Votes" : "\(posts[indexPath.row].votes!) Vote"
        cell.postImage.image = UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath))
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            for username in posts[indexPath.row].voters! {
                if username == loggedInUser.username {
                    cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                    break
                }
            }
        }
        // cell.postTimeLabel.text = getPostedTimeFormated(posts[indexPath.row].posted) -> test new uploaded image
    
        return cell
    }
    
}

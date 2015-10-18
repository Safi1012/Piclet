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
    
    func userPressedLike(sender: UITapGestureRecognizer) {
        
        
        
        print(sender.view)
        
        
        
        
        
        
        
    }
    
    
    // MARK: - Posts
    
    func refreshPosts() {
        showLoadingSpinner()
        
        ApiProxy().getChallengesPosts(challengeID!, success: { (posts) -> () in
            
            self.hideLoadingSpinner()
            
            self.posts = posts
            
            if !self.checkIfThumbnailsExists() {
                self.getThumbnailsOfChallenge()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
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
        
        // let calenderUnit = [NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second]
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
    
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        cell.postID = posts[indexPath.row].id
        
        // gesture recognizer
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "userPressedLike:")
            doubleTapRecognizer.numberOfTapsRequired = 2
        cell.postImage.userInteractionEnabled = true
        cell.postImage.addGestureRecognizer(doubleTapRecognizer)

        
        
        let imagePath = documentPath.stringByAppendingPathComponent(posts[indexPath.row].id! + "_medium" + ".webp")

        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = posts[indexPath.row].votes! > 1 ? "\(posts[indexPath.row].votes!) Votes" : "\(posts[indexPath.row].votes!) Vote"
        
        
        UIImage.imageWithWebP(imagePath, completionBlock: { (image) -> Void in
            cell.postImage.image = image
        }) { (error) -> Void in
            cell.postImage.image = UIImage(named: "challengePreviewPlaceholder")
        }
        
        
        
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            for username in posts[indexPath.row].voters! {
                if username == loggedInUser.username {
                    cell.postLikeImage.image = UIImage(named: "likeFilled")
                }
            }
        }
        
        // TEST
        // cell.postTableViewController = self
        
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        // cell.postTimeLabel.text = getPostedTimeFormated(posts[indexPath.row].posted)
    
        return cell
    }

    
    // MARK: - tableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("TEST")
    }
    
}

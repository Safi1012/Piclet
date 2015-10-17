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
    
    
    
    // MARK: - Challenge
    
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
            
            ApiProxy().getPostImageInSize(nil, challengeID: challengeID!, postID: post.id!, imageSize: ImageSize.big, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }) { (errorCode) -> () in
                self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
            }
        }
    }

    func checkIfThumbnailsExists() -> Bool {
        
        for post in posts {
            let imagePath = documentPath.stringByAppendingPathComponent(post.id! + ".webp")
            
            if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                return false
            }
        }
        return true
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
        
        let imagePath = documentPath.stringByAppendingPathComponent(posts[indexPath.row].id! + ".webp")

        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = "\(posts[indexPath.row].votes!) Votes"
        
        UIImage.imageWithWebP(imagePath, completionBlock: { (image) -> Void in
            cell.postImage.image = UIImage(webPData: NSData(contentsOfFile: imagePath))
        }) { (error) -> Void in
            cell.postImage.image = UIImage(named: "challengePreviewPlaceholder")
        }
        
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = "2 min ago"
    
        return cell
    }

}

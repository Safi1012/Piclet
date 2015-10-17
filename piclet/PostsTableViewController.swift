//
//  PostsTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 17/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
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
    
    override func viewWillDisappear(animated: Bool) {
        self.challenge!.posts = nil
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
        
        ApiProxy().getChallengesPosts(challenge!.id!, success: { (posts) -> () in
            
            
            self.challenge!.posts = posts
            
            if !self.checkIfThumbnailsExists() {
                self.getThumbnailsOfChallenge()
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            self.hideLoadingSpinner()
            
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
        }
    }
    
    func getThumbnailsOfChallenge() {
        
        for post in challenge!.posts! {
            
            ApiProxy().getPostImageInSize(nil, challengeID: challenge!.id!, postID: post.id!, imageSize: ImageSize.big, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }) { (errorCode) -> () in
                self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }

    func checkIfThumbnailsExists() -> Bool {
        
        for post in challenge!.posts! {
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
        return challenge?.posts?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        
        let imagePath = documentPath.stringByAppendingPathComponent(challenge!.posts![indexPath.row].id! + ".webp")

        cell.postDescriptionLabel.text = challenge?.posts![indexPath.row].description
        cell.postVotesLabel.text = "\((challenge?.posts![indexPath.row].votes!)!) Votes"
        cell.postImage.image = UIImage(webPData: NSData(contentsOfFile: imagePath)) ?? UIImage(named: "challengePreviewPlaceholder")
        cell.postUsernameLabel.text = challenge?.posts![indexPath.row].creator
        cell.postTimeLabel.text = "2 min ago"
    
        return cell
    }

}

//
//  ChallengeTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeTableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    
    let apiProxy = ApiProxy()
    var challenges = [Challenge]()
    var timestamp: NSDate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshChallenges()
        timestamp = NSDate()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        refreshChallenges()
    }


    
    // MARK: - Challenge
    
    func refreshChallenges() {
        // showLoadingSpinner()
        
        apiProxy.getChallenges(nil, offset: "5000", success: { (challenges) -> () in
            // self.hideLoadingSpinner()
            self.challenges = challenges
            
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
        
        for challenge in challenges {
            
            apiProxy.getPostImageInSize(nil, challengeID: challenge.id!, postID: challenge.creatorPost!, imageSize: ImageSize.small, imageFormat: ImageFormat.webp, success: { () -> () in
                
            }) { (errorCode) -> () in
                self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
            }
        }
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func checkIfThumbnailsExists() -> Bool {
        
        for challenge in challenges {
            let imagePath = documentPath.stringByAppendingPathComponent(challenge.creatorPost! + "_small" + ".webp")
            
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
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return challenges.count == 0 ? 0 : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        let imagePath = documentPath.stringByAppendingPathComponent(challenges[indexPath.row].creatorPost! + "_small" + ".webp")
        
        cell.titleLabel.text = challenges[indexPath.row].title
        cell.timePostedLabel.text = getPostedTimeFormated(challenges[indexPath.row].posted!)
        cell.votesLabel.text = challenges[indexPath.row].votes > 0 ? "\(challenges[indexPath.row].votes!) votes" : "\(challenges[indexPath.row].votes!) vote"
        cell.previewImageView.image = UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath))
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challenge = challenges[indexPath.row]
        self.performSegueWithIdentifier("toPostsViewController", sender: challenge)
    }
    
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsTableViewController
            destinationVC.challengeID = (sender as? Challenge)?.id
        }
    }
}









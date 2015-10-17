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
        
        let secondsDifference = NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: timestamp!, toDate: NSDate(), options: NSCalendarOptions.init(rawValue: 0)).second
        
        if secondsDifference > 120 {
            timestamp = NSDate()
            refreshChallenges()
        }
    }
    
    
    // MARK: - Challenge
    
    func refreshChallenges() {
        showLoadingSpinner()
        
        apiProxy.getChallenges(nil, offset: "10", success: { (challenges) -> () in
            self.hideLoadingSpinner()
            self.challenges = challenges
            
            if self.checkIfThumbnailsExists() {
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
            let imagePath = documentPath.stringByAppendingPathComponent(challenge.creatorPost! + ".webp")
            
            if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                return false
            }
        }
        return true
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
        
        let imagePath = documentPath.stringByAppendingPathComponent(challenges[indexPath.row].creatorPost! + ".webp")
        
        cell.titleLabel.text = challenges[indexPath.row].title
        cell.timePostedLabel.text = challenges[indexPath.row].posted ?? "0" + " min"
        cell.votesLabel.text = challenges[indexPath.row].votes ?? "0" + " votes"
        cell.previewImageView.image = UIImage(webPData: NSData(contentsOfFile: imagePath)) ?? UIImage(named: "challengePreviewPlaceholder")
    
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
            destinationVC.challenge = sender as? Challenge
        }
    }
}









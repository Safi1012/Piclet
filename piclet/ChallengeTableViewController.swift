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
    
    func refreshChallenges() {
        // showLoadingSpinner()
        
        apiProxy.getChallenges(nil, offset: "20", success: { (challenges) -> () in
            
            self.challenges = challenges
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.hideLoadingSpinner()
            })
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(UIAlertController.createErrorAlert(errorCode))
        }
    }
    

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return challenges.count > 0 ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        cell.titleLabel.text = challenges[indexPath.row].title
        cell.timePostedLabel.text = TimeHandler().getPostedTimestampFormated(challenges[indexPath.row].posted!)
        cell.votesLabel.text = challenges[indexPath.row].votes > 0 ? "\(challenges[indexPath.row].votes!) votes" : "\(challenges[indexPath.row].votes!) vote"
        
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









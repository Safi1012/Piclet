//
//  ChallengeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 23/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    let apiProxy = ApiProxy()
    var challenges = [Challenge]()
    
    var hotTimestamp: NSDate?
    var newTimestamp: NSDate?
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavigationBar()
        tableView.dataSource = self
        
        
        print("\(segmentedControl.titleForSegmentAtIndex(0))")
        print("\(segmentedControl.titleForSegmentAtIndex(1))")
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        refreshChallenges()
    }
    
    
    
    // MARK: - UI
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentPixel"), forBarMetrics: UIBarMetrics.Default)
    }
    
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
                // self.hideLoadingSpinner()
            })
            
        }) { (errorCode) -> () in
            
            // self.hideLoadingSpinner()
            self.displayAlert(UIAlertController.createErrorAlert(errorCode))
            
        }
    }
    
//    func refreshHotChallenges() {
//        // toDo
//        // time fetch only after 5 minutes new..
//        if shouldRefreshChallenge(<#T##timestamp: NSDate?##NSDate?#>)
//    
//    }
//    
//    func refreshNewChallenges() {
//        // toDo
//    }
    
    
    
    
    func shouldRefreshChallenge(var timestamp: NSDate?) -> Bool {   
        if var timestamp = timestamp {
            if TimeHandler().secondsPassedSinceDate(timestamp) > 300 {
                timestamp = NSDate()
                return true
            } else {
                return false
            }
        }
        timestamp = NSDate()
        return true
    }
    
    func formatVoteText(numberVotes: Int?) -> String {
        guard
            let numberVotes = numberVotes
        else {
            return "0 votes"
        }
        
        if numberVotes > 0 || numberVotes == 0 {
            return "\(numberVotes) votes"
        }
        return "\(numberVotes) vote"
    }
    
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsTableViewController
            destinationVC.challengeID = (sender as? Challenge)?.id
        }
    }
}



// MARK: - UITableViewDataSource

extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return challenges.count > 0 ? 1 : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        cell.challengeTitleLabel.text = challenges[indexPath.row].title
        cell.timepostedLabel.text = TimeHandler().getPostedTimestampFormated(challenges[indexPath.row].posted!)
        // cell.numberPostsLabel.text =
        cell.numberLikesLabel.text = formatVoteText(challenges[indexPath.row].votes)
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let challenge = challenges[indexPath.row]
        self.performSegueWithIdentifier("toPostsViewController", sender: challenge)
    }
}



// MARK: - UITableViewDelegate

extension ChallengeViewController: UITableViewDelegate {
    
}


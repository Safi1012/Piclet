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
    
    var challengeCollection: ChallengeCollection!

    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleNavigationBar()
        tableView.dataSource = self
        tableView.delegate = self
        // self.makePullToRefreshToTableView(tableView, triggerToMethodName: "test") // todo: call method which refreshes -> check how offset should work
        
        if segmentedControl.selectedSegmentIndex == SegmentedControlState.hot.rawValue {
            challengeCollection = ChallengeCollection(section: SegmentedControlState.hot)
        } else  {
            challengeCollection = ChallengeCollection(section: SegmentedControlState.new)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        tableView.flashScrollIndicators()
        refreshSelectedSection(0) // todo: check whether hot | new -> pick the right offset (tableView)
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

    @IBAction func pressedSegmentedControl(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == SegmentedControlState.hot.rawValue {
            challengeCollection.section = SegmentedControlState.hot
        } else {
            challengeCollection.section = SegmentedControlState.new
        }
        refreshSelectedSection(0) // todo: check whether hot | new -> pick the right offset (tableView)
    }

    
    // MARK: - Challenge
    
    func refreshSelectedSection(offset: Int) {
        if shouldRefreshChallenge(challengeCollection.timestamp) {
            refreshChallenges(offset, order: challengeCollection.section)
        }
    }
    
    func refreshChallenges(offset: Int, order: SegmentedControlState) {
        
        apiProxy.getChallenges(nil, offset: offset, orderby: order, success: { (challenges) -> () in
            self.challengeCollection.challenge = challenges
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.makePullToRefreshEndRefreshing()
            })
            
        }) { (errorCode) -> () in
            self.makePullToRefreshEndRefreshing()
            self.displayAlert(errorCode)
            
        }
    }
    
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
    
    func refreshChallenges() {
        
    }
    
    func formatVoteText(numberVotes: Int) -> String {
        if numberVotes == 1 {
            return "\(numberVotes) vote"
        }
        return "\(numberVotes) votes"
    }
    
    func formatNumberPosts(numberPosts: Int) -> String {
        if numberPosts == 1 {
            return "\(numberPosts) post"
        }
        return "\(numberPosts) posts"
    }
    
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsTableViewController
            destinationVC.challenge = (sender as? Challenge)
        }
    }
}



// MARK: - UITableViewDataSource

extension ChallengeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return challengeCollection.challenge.count > 0 ? 1 : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challengeCollection.challenge.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        cell.challengeTitleLabel.text = challengeCollection.challenge[indexPath.row].title
        cell.timepostedLabel.text = TimeHandler().getPostedTimestampFormated(challengeCollection.challenge[indexPath.row].posted)
        cell.numberPostsLabel.text = formatNumberPosts(challengeCollection.challenge[indexPath.row].amountPosts)
        cell.numberLikesLabel.text = formatVoteText(challengeCollection.challenge[indexPath.row].votes)
    
        return cell
    }
}



// MARK: - UITableViewDelegate

extension ChallengeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        let challenge = challengeCollection.challenge[indexPath.row]
        self.performSegueWithIdentifier("toPostsViewController", sender: challenge)
    }
}


// MARK: - SegmentedControlState Enum

enum SegmentedControlState: Int {
    case hot = 0
    case new = 1
}


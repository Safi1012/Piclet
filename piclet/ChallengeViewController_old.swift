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
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var activityIndicator: ActivityIndicatorView!
    var challengeCollection: ChallengeCollection!
    var isRequesting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        styleNavigationBar()
        styleTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.addPullToRefresh(tableView, selector: "refresh")
        
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
        refreshSelectedSection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }

    
    
    // MARK: - UI
    
    func setupActivityIndicator() {
        activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.center = CGPointMake(activityIndicatorView.bounds.midX, activityIndicatorView.bounds.midY)
        activityIndicatorView.hidden = true
    }
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentPixel"), forBarMetrics: UIBarMetrics.Default)
    }
    
    func styleTableView() {
        let border = CALayer()
        border.backgroundColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        border.frame = CGRect(x: 15, y: 0, width: tableViewFooter.frame.width - 15.0, height: 0.5)
        tableViewFooter.layer.addSublayer(border)
    }
    
    func startActivityIndicator() {
        activityIndicatorView.hidden = false
        activityIndicator.startAnimating()
    }

    func stopActivityIndicator() {
        activityIndicatorView.hidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func pressedSegmentedControl(sender: UISegmentedControl) {
        challengeCollection.offsetY = tableView.contentOffset.y
        
        if sender.selectedSegmentIndex == SegmentedControlState.hot.rawValue {
            challengeCollection.section = SegmentedControlState.hot
        } else {
            challengeCollection.section = SegmentedControlState.new
        }
        
        tableView.contentOffset.y = challengeCollection.offsetY
        refreshSelectedSection()
    }

    @IBAction func pressedCreateChallenge(sender: UIBarButtonItem) {
        if let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            if loggedInUser.token != nil {
                performSegueWithIdentifier("toCreateChallengeViewController", sender: self)
                return
            }
        }
        self.displayAlert("NotLoggedIn")
    }

    
    
    // MARK: - Challenge
    
    func refreshSelectedSection() {
        if shouldRefreshChallenge() {
            refresh()
        } else {
            tableView.reloadData()
        }
    }
    
    func refreshChallenges(offset: Int) {
        if isRequesting {
            return
        }
        fetchChallenges(offset, displayIndicator: true)
    }
    
    func fetchChallenges(offset: Int, displayIndicator: Bool) {
        isRequesting = true
        if displayIndicator { startActivityIndicator() }
        
        ApiProxy().fetchChallenges(offset, orderby: self.challengeCollection.section, archived: false, success: { (challenges) -> () in
            for challenge in challenges {
                self.challengeCollection.challenge.append(challenge)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.makePullToRefreshEndRefreshing()
                self.isRequesting = false
                self.stopActivityIndicator()
            })
            
        }) { (errorCode) -> () in
            self.makePullToRefreshEndRefreshing()
            self.displayAlert(errorCode)
            self.isRequesting = false
            self.stopActivityIndicator()
                
        }
    }
    
    func shouldRefreshChallenge() -> Bool {
        
        if challengeCollection.timestamp != nil {
            if TimeHandler().secondsPassedSinceDate(challengeCollection.timestamp!) > 300 {
                challengeCollection.timestamp = NSDate()
                return true
            } else {
                return false
            }
        }
        challengeCollection.timestamp = NSDate()
        return true
    }
    
    func refresh() {
        challengeCollection.challenge = [Challenge]()
        challengeCollection.offsetY = 0.0
        
        // very important! otherwise the tableView will crash because the number of rows are wrong after wiping the data
        self.tableView.reloadData()
        fetchChallenges(0, displayIndicator: false)
    }
    

    
    // create new class that formats code!
    
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
            let destinationVC = segue.destinationViewController as! PostsViewController
            destinationVC.challenge = (sender as? Challenge)
        }
        if segue.identifier == "toCreateChallengeViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! CreateChallengeViewController
            destinationVC.token = User.getLoggedInUser(AppDelegate().managedObjectContext)!.token!
        }
    }
    
    @IBAction func unwindToChallengeViewController(segue: UIStoryboardSegue) {}
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset) <= 70 {
            refreshChallenges(challengeCollection.challenge.count + 20)
        }
    }
}


// MARK: - SegmentedControlState Enum

enum SegmentedControlState: Int {
    case hot = 0
    case new = 1
}


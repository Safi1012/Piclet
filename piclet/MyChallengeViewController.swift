//
//  MyChallengeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 09/01/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class MyChallengeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userAccount: UserAccount!
    var isRequesting = false
    var challenges: [Challenge]!
    var wonChallenges = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        challenges = [Challenge]()
        
        addDefaultPullToRefresh(tableView, selector: "refresh")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addActivityIndicatorFooterView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.flashScrollIndicators()
        showLoadingSpinner(UIOffset(), color: UIColor.blackColor())
        refreshChallenges(0)
    }
    
    
    // MARK: - Challenge
    
    func refresh() {
        fetchChallenges(0, displayIndicator: false)
    }
    
    func refreshChallenges(offset: Int) {
        if isRequesting {
            return
        }
        if wonChallenges {
            fetchWonChallenges(offset, displayIndicator: true)
        } else {
            fetchChallenges(offset, displayIndicator: true)
        }
    }
    
    func fetchChallenges(offset: Int, displayIndicator: Bool) {
        isRequesting = true
        
        ApiProxy().fetchUserCreatedChallenges(userAccount.username, offset: offset, success: { (userChallenges) -> () in
            self.fetchUserSuccess(offset, userChallenges: userChallenges)
            
        }) { (errorCode) -> () in
            self.fetchUserFailure(errorCode)
        }
    }
    
    func fetchWonChallenges(offset: Int, displayIndicator: Bool) {
        isRequesting = true
        
        ApiProxy().fetchWonChallenges(offset, username: userAccount.username, success: { (userChallenges) in
            self.fetchUserSuccess(offset, userChallenges: userChallenges)
            
        }) { (errorCode) in
            self.fetchUserFailure(errorCode)
        }
    }
    
    func fetchUserSuccess(offset: Int, userChallenges: [Challenge]) {
        removeCentered(tableView)
        
        if offset == 0 {
            challenges = [Challenge]()
        }
        for challenge in userChallenges {
            challenges.append(challenge)
        }
        
        if challenges.count == 0 {
            if wonChallenges {
                addCenteredLabel("You didn't win any challenges", view: tableView)
            } else {
                addCenteredLabel("You don't have any challenges. \n Let's go and create one!", view: tableView)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            self.isRequesting = false
            self.tableView.stopAnimatingIndicatorView()
            self.dismissLoadingSpinner()
        })
    }
    
    func fetchUserFailure(errorCode: String) {
        displayAlert(errorCode)
        isRequesting = false
        tableView.stopAnimatingIndicatorView()
        dismissLoadingSpinner()
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsViewController
            destinationVC.challenge = (sender as? Challenge)
        }
        if segue.identifier == "toCreateChallengeViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! CreateChallengeViewController
            
            if let token = UserAccess.sharedInstance.getUser()?.token {
               destinationVC.token = token
            }
        }
    }
}


// MARK: - UITableViewDataSource

extension MyChallengeViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.challenges.count > 0 ? 1 : 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.challenges.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        cell.challengeTitleLabel.text = self.challenges[indexPath.row].title
        cell.timepostedLabel.text = TimeHandler().getPostedTimestampFormated(self.challenges[indexPath.row].posted)
        cell.numberPostsLabel.text = Formater().formatSingularAndPlural(self.challenges[indexPath.row].amountPosts, singularWord: "post")
        cell.numberLikesLabel.text = Formater().formatSingularAndPlural(self.challenges[indexPath.row].votes, singularWord: "vote")
        
        return cell
    }
}


// MARK: - UITableViewDelegate

extension MyChallengeViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
        self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.None)
        let challenge = self.challenges[indexPath.row]
        self.performSegueWithIdentifier("toPostsViewController", sender: challenge)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 70 {
            tableView.startAnimatingIndicatorView()
            refreshChallenges((self.challenges.count - 20) + 20)
        }
    }
}

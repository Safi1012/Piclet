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
    @IBOutlet weak var tableViewFooter: UIView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    var userAccount: UserAccount!
    var activityIndicator: ActivityIndicatorView!
    var isRequesting = false
    var challenges: [Challenge]!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.challenges = [Challenge]()
        setupActivityIndicator()
        styleTableView()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.flashScrollIndicators()
        refreshChallenges(0)
    }

    
    // MARK: - UI
    
    func setupActivityIndicator() {
        activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.center = CGPointMake(activityIndicatorView.bounds.midX, activityIndicatorView.bounds.midY)
        activityIndicatorView.hidden = true
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
    

    
    
    
    // MARK: - Challenge
    
    func refreshChallenges(offset: Int) {
        if isRequesting {
            return
        }
        fetchChallenges(offset, displayIndicator: true)
    }
    
    func fetchChallenges(offset: Int, displayIndicator: Bool) {
        isRequesting = true
        if displayIndicator { startActivityIndicator() }
        
        ApiProxy().fetchUserCreatedChallenges(userAccount.username, offset: offset, success: { (userChallenges) -> () in
            for challenge in userChallenges {
                self.challenges.append(challenge)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.isRequesting = false
                self.stopActivityIndicator()
            })
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            self.isRequesting = false
            self.stopActivityIndicator()
        }
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
        cell.numberPostsLabel.text = formatNumberPosts(self.challenges[indexPath.row].amountPosts)
        cell.numberLikesLabel.text = formatVoteText(self.challenges[indexPath.row].votes)
        
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
            refreshChallenges(self.challenges.count + 20)
        }
    }
}

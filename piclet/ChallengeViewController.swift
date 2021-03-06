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
    
    var challengeCollection: ChallengeCollection!
    var isRequesting = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        challengeCollection = ChallengeCollection(section: SegmentedControlState.hot)
        setupTableView()
        styleNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        tableView.flashScrollIndicators()
        refreshSelectedSegement()
    }

    
    // MARK: - Action
    
    @IBAction func pressedCreateButton(sender: UIBarButtonItem) {
        if (UserAccess.sharedInstance.getUser() != nil) {
            let createChallengeNavgiationController = UIStoryboard.init(name: "ChallengeCreate", bundle: nil).instantiateInitialViewController()!
            presentViewController(createChallengeNavgiationController, animated: true, completion: nil)
        } else {
            displayAlert("NotLoggedIn")
        }
    }
    
    
    // MARK: - SetupUI
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.addActivityIndicatorFooterView()
        
        addDefaultPullToRefresh(tableView, selector: "refresh")
    }
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentPixel"), forBarMetrics: UIBarMetrics.Default)
    }
    
    
    // MARK: - UserBehaviour
    
    @IBAction func pressedSegmentedControl(sender: UISegmentedControl) {
        challengeCollection.offsetY = tableView.contentOffset.y
        removeCentered(tableView)
        
        switch sender.selectedSegmentIndex {
            
        case SegmentedControlState.hot.rawValue:
            challengeCollection.section = SegmentedControlState.hot
            
        case SegmentedControlState.new.rawValue:
            challengeCollection.section = SegmentedControlState.new
            
        case SegmentedControlState.archived.rawValue:
            challengeCollection.section = SegmentedControlState.archived
            
        default:
            challengeCollection.section = SegmentedControlState.hot
        }
        
        tableView.contentOffset.y = challengeCollection.offsetY
        refreshSelectedSegement()
    }

    @IBAction func pressedCreateChallenge(sender: UIBarButtonItem) {
        
        if UserAccess.sharedInstance.isUserLoggedIn() {
            performSegueWithIdentifier("toCreateChallengeViewController", sender: self)
        } else {
            self.displayAlert("NotLoggedIn")
        }
    }
    

    // MARK: - Challenge
    
    func refreshSelectedSegement() {

        if shouldRefreshData(&challengeCollection.timestamp) {
            tableView.hidden = true
            showLoadingSpinner(UIOffset(), color: UIColor.blackColor())
            refresh()
        } else {
            tableView.reloadData()
            
            if challengeCollection.challenge.count == 0 {
                addCenteredLabel("There are no challenges yet. \n Let's go and create one!", view: tableView)
            } else {
                removeCentered(tableView)
            }
        }
    }
    
    func refresh() {
        if challengeCollection.section == .archived {
            fetchChallenges(0, displayIndicator: false, isFullRefetch: true, archived: true)
        } else {
            fetchChallenges(0, displayIndicator: false, isFullRefetch: true, archived: false)
        }
    }
    
    func infiniteLoading(offset: Int) {
        if isRequesting {
            return
        }
        if challengeCollection.section == .archived {
            fetchChallenges(offset, displayIndicator: true, isFullRefetch: false, archived: true)
        } else {
            fetchChallenges(offset, displayIndicator: true, isFullRefetch: false, archived: false)
        }
    }
    
    func fetchChallenges(offset: Int, displayIndicator: Bool, isFullRefetch: Bool, archived: Bool) {
        isRequesting = true
        if displayIndicator { tableView.tableFooterView?.startAnimatingIndicatorView() }
        
        ApiProxy().fetchChallenges(offset, orderby: self.challengeCollection.section, archived: archived, success: { (challenges) -> () in
            if offset == 0 {
                self.challengeCollection.challenge = [Challenge]()
                self.challengeCollection.offsetY = 0.0
            }
            
            for challenge in challenges {
                self.challengeCollection.challenge.append(challenge)
            }
            self.tableView.reloadData()
            self.requestFinished()

        }) { (errorCode) -> () in
            self.requestFinished()
            self.displayAlert(errorCode)
            if isFullRefetch { self.challengeCollection.timestamp = nil }
        }
    }
    
    func requestFinished() {
        tableView.hidden = false
        self.makePullToRefreshEndRefreshing()
        self.dismissLoadingSpinner()
        self.tableView.tableFooterView?.stopAnimatingIndicatorView()
        
        isRequesting = false
        
        if challengeCollection.challenge.count == 0 {
            addCenteredLabel("There are no challenges yet. \n Let's go and create one!", view: tableView)
        } else {
            removeCentered(tableView)
        }
    }


    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsViewController
            destinationVC.challenge = (sender as? Challenge)
        }
        if segue.identifier == "toCreateChallengeViewController" {
            
            if let token = UserAccess.sharedInstance.getUser()?.token {
                let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! CreateChallengeViewController
                destinationVC.token = token
            }
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
        cell.numberPostsLabel.text = Formater().formatSingularAndPlural(challengeCollection.challenge[indexPath.row].amountPosts, singularWord: "post")
        cell.numberLikesLabel.text = Formater().formatSingularAndPlural(challengeCollection.challenge[indexPath.row].votes, singularWord: "vote")
    
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
            infiniteLoading((challengeCollection.challenge.count - 20) + 20)
        }
    }
}


// MARK: - SegmentedControlState Enum

enum SegmentedControlState: Int {
    case hot = 0
    case new = 1
    case archived = 2
}


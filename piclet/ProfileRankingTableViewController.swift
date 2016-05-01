//
//  ProfileRankingTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/05/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class ProfileRankingTableViewController: UITableViewController {

    var userRanks = [UserRank]()
    var isRequesting = false
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.addActivityIndicatorView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoadingSpinner(UIOffset(), color: UIColor.blackColor())
        refreshRanks(0)
    }
    

    // MARK: - Load Rank
    
    func refresh() {
        fetchRanks(0, displayIndicator: false)
    }
    
    func refreshRanks(offset: Int) {
        if isRequesting {
            return
        }
        fetchRanks(offset, displayIndicator: true)
    }
    
    func fetchRanks(offset: Int, displayIndicator: Bool) {
        isRequesting = true
        
        ApiProxy().fetchRanks(offset, success: { (ranks) in
            if offset == 0 {
                self.userRanks = [UserRank]()
            }
            for rank in ranks {
                self.userRanks.append(rank)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.isRequesting = false
                self.tableView.stopAnimatingIndicatorView()
                self.dismissLoadingSpinner()
            })
            
        }) { (errorCode) in
            self.displayAlert(errorCode)
            self.isRequesting = false
            self.tableView.stopAnimatingIndicatorView()
            self.dismissLoadingSpinner()
            
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return userRanks.count > 0 ? 1 : 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRanks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ProfileRankingTableViewCell
        let url = NSURL(string: "https://flash1293.de/users/\(userRanks[indexPath.row].username)/avatar-\(ImageSize.medium).\(ImageFormat.jpeg)")
        
        cell.rankLabel.text = "\(userRanks[indexPath.row].rank)"
        cell.usernameLabel.text = userRanks[indexPath.row].username
        cell.avatarImageView.sd_setImageWithURL(url)
       
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        if (maximumOffset - currentOffset) <= 70 {
            tableView.startAnimatingIndicatorView()
            refreshRanks((self.userRanks.count - 20) + 20)
        }
    }
}

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
    
    @IBOutlet weak var activityIndicatorView: UIView!
    @IBOutlet weak var tableViewFooter: UIView!
    
    var userRanks = [UserRank]()
    var isRequesting = false
    var activityIndicator: ActivityIndicatorView!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        styleTableView()
        setupActivityIndicator()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        showLoadingSpinner(UIOffset(), color: UIColor.blackColor())
        refreshRanks(0)
    }
    
    func styleTableView() {
        let border = CALayer()
        border.backgroundColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
        border.frame = CGRect(x: 15, y: 0, width: tableViewFooter.frame.width - 15.0, height: 0.5)
        tableViewFooter.layer.addSublayer(border)
    }
    
    func setupActivityIndicator() {
        activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
        activityIndicatorView.addSubview(activityIndicator)
        activityIndicator.center = CGPointMake(activityIndicatorView.bounds.midX, activityIndicatorView.bounds.midY)
        activityIndicatorView.hidden = true
    }
    
    func startActivityIndicator() {
        activityIndicatorView.hidden = false
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicatorView.hidden = true
        activityIndicator.stopAnimating()
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
                self.stopActivityIndicator()
                self.dismissLoadingSpinner()
            })
            
        }) { (errorCode) in
            self.displayAlert(errorCode)
            self.isRequesting = false
            self.stopActivityIndicator()
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
            startActivityIndicator()
            refreshRanks((self.userRanks.count - 20) + 20)
        }
    }
}

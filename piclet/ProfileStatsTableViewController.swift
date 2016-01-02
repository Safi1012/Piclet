//
//  ProfileStatsTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileStatsTableViewController: UITableViewController {
    
    @IBOutlet weak var rankCell: UITableViewCell!
    @IBOutlet weak var totalLikesCell: UITableViewCell!
    
    
    
    
    // var userAccount: UserAccount?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let parentVC = self.parentViewController as! ProfilViewController
        // parentVC.delegate = self
    }

    
    // MARK: - Table view data source
//
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 2
//    }
    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        tableView.de
//        
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
//        
//        switch(indexPath.row) {
//            
//        case 0:
//            cell.detailTextLabel?.text = "\(userAccount!.rank)"
//            
//        case 1:
//            cell.detailTextLabel?.text = "\(userAccount!.totalVotes)"
//            
//        default:
//            cell.detailTextLabel?.text = "0"
//            
//        }
//        return cell
//    }
    
}


// MARK: - ProfileViewControllerDelegate

extension ProfileStatsTableViewController: ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfilViewController, userAccount: UserAccount) {
        
        rankCell.detailTextLabel?.text = "\(userAccount.rank)"
        totalLikesCell.detailTextLabel?.text = "\(userAccount.totalVotes)"
        
        tableView.reloadData()
    }
}

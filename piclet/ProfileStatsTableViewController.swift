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
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell == rankCell {
            self.parentViewController?.performSegueWithIdentifier("toRanking", sender: nil)
        }
        if cell == totalLikesCell {
            // self.parentViewController?.performSegueWithIdentifier("toUserChallenges", sender: userAccount!)
        }
    }
}


// MARK: - ProfileViewControllerDelegate

extension ProfileStatsTableViewController: ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfileViewController, userAccount: UserAccount) {
        rankCell.detailTextLabel?.text = "\(userAccount.rank)"
        totalLikesCell.detailTextLabel?.text = "\(userAccount.totalVotes)"
        
        tableView.reloadData()
    }
}

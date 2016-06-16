//
//  ProfileHistoryTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileHistoryTableViewController: UITableViewController {

    @IBOutlet weak var postsCell: UITableViewCell!
    @IBOutlet weak var likedCell: UITableViewCell!
    @IBOutlet weak var challengesCell: UITableViewCell!
    @IBOutlet weak var wonCell: UITableViewCell!
    
    var userAccount: UserAccount?
    
    override func viewWillAppear(animated: Bool) {
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if let userAccount = userAccount {
            if cell == postsCell {
                self.parentViewController?.performSegueWithIdentifier("toProfileCollectionView", sender: userAccount)
            }
            if cell == challengesCell {
                self.parentViewController?.performSegueWithIdentifier("toUserChallenges", sender: userAccount)
            }
            if cell == likedCell {
                self.parentViewController?.performSegueWithIdentifier("toLikedPosts", sender: userAccount)
            }
            if cell == wonCell {
                self.parentViewController?.performSegueWithIdentifier("toWonChallenges", sender: userAccount)
            }
        }
        
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard
            let userAccount = self.userAccount
        else {
            return
        }
        
        if segue.identifier == "toProfileCollectionView" {
            let destinationVC = segue.destinationViewController as! ProfileCollectionViewController
            destinationVC.userAccount = userAccount
        }
    }
}


// MARK: - ProfileViewControllerDelegate

extension ProfileHistoryTableViewController: ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfileViewController, userAccount: UserAccount) {
        
        self.userAccount = userAccount
        
        postsCell.detailTextLabel?.text = "\(userAccount.totalPosts)"
        likedCell.detailTextLabel?.text = "\(userAccount.totalLikedPosts)"
        challengesCell.detailTextLabel?.text = "\(userAccount.totalChallenges)"
        wonCell.detailTextLabel?.text = "\(userAccount.totalWonChallenges)"
        
        tableView.reloadData()
    }
}

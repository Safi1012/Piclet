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
                let profileCollectionViewController = UIStoryboard(name: "ProfilePosts", bundle: nil).instantiateInitialViewController() as! ProfileCollectionViewController
                    profileCollectionViewController.loadPostType = LoadPostsType.ownPosts
                    profileCollectionViewController.userAccount = userAccount
                
                self.parentViewController?.navigationController?.pushViewController(profileCollectionViewController, animated: true)
            }
            if cell == likedCell {
                let profileCollectionViewController = UIStoryboard(name: "ProfilePosts", bundle: nil).instantiateInitialViewController() as! ProfileCollectionViewController
                    profileCollectionViewController.loadPostType = LoadPostsType.likedPosts
                    profileCollectionViewController.userAccount = userAccount
                
                self.parentViewController?.navigationController?.pushViewController(profileCollectionViewController, animated: true)
            }
            if cell == challengesCell {
                let profileChallengeViewController = UIStoryboard(name: "ProfileChallenge", bundle: nil).instantiateInitialViewController() as! MyChallengeViewController
                    profileChallengeViewController.userAccount = userAccount
                
                self.parentViewController?.navigationController?.pushViewController(profileChallengeViewController, animated: true)
            }
            if cell == wonCell {
                let profileChallengeViewController = UIStoryboard(name: "ProfileChallenge", bundle: nil).instantiateInitialViewController() as! MyChallengeViewController
                    profileChallengeViewController.userAccount = userAccount
                    profileChallengeViewController.wonChallenges = true
                
                self.parentViewController?.navigationController?.pushViewController(profileChallengeViewController, animated: true)
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

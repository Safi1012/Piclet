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
    
    var userAccount: UserAccount?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = self.tableView.indexPathForSelectedRow {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell == rankCell {
            let profileRankViewController = UIStoryboard(name: "ProfileRank", bundle: nil).instantiateInitialViewController() as! ProfileRankingTableViewController
            self.parentViewController?.navigationController?.pushViewController(profileRankViewController, animated: true)
        }
        if cell == totalLikesCell {
            let profileCollectionViewController = UIStoryboard(name: "ProfilePosts", bundle: nil).instantiateInitialViewController() as! ProfileCollectionViewController
                profileCollectionViewController.loadPostType = LoadPostsType.earnedLikesPosts
                profileCollectionViewController.userAccount = userAccount
            
            self.parentViewController?.navigationController?.pushViewController(profileCollectionViewController, animated: true)
        }
    }
}


// MARK: - ProfileViewControllerDelegate

extension ProfileStatsTableViewController: ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfileViewController, userAccount: UserAccount) {
        self.userAccount = userAccount
        
        rankCell.detailTextLabel?.text = "\(userAccount.rank)"
        totalLikesCell.detailTextLabel?.text = "\(userAccount.totalVotes)"
        
        tableView.reloadData()
    }
}

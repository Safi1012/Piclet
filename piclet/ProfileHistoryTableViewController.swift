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
    
    var userAccount: UserAccount?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


// MARK: - ProfileViewControllerDelegate

extension ProfileHistoryTableViewController: ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfilViewController, userAccount: UserAccount) {
        
        self.userAccount = userAccount
        
        postsCell.detailTextLabel?.text = "\(userAccount.totalPosts)"
        likedCell.detailTextLabel?.text = "Unknown"
        challengesCell.detailTextLabel?.text = "Unknown"
        
        tableView.reloadData()
    }
}

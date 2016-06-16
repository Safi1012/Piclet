//
//  ProfileViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileStatsContainer: UIView!
    @IBOutlet weak var profileStatsHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileHistoryContainer: UIView!
    @IBOutlet weak var profileHistoryHeightConstraint: NSLayoutConstraint!
    
    
//    @IBOutlet weak var profileImageContainer: UIView!
//    @IBOutlet weak var profileStatsContainer: UIView!
//    @IBOutlet weak var profileHistoryContainer: UIView!
//    @IBOutlet weak var scrollView: UIScrollView!
    
    var userName: String?
    var token: String?
    var loadedDataTimestamp: NSDate?
    var profileStatsDelegate: ProfileViewControllerDelegate?
    var profileHistoryDelegate: ProfileViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
//        
//        getLoginInformation()
//        embedProfileAvatar()
//        addDefaultPullToRefresh(scrollView, selector: "fetchUserInformation")
        
        embedProfileInformation()
    }
    
    override func viewWillAppear(animated: Bool) {
        // fetchUserInformation()
    }
    
    
    func embedProfileInformation() {
        let storyboardProfileStats = UIStoryboard(name: "ProfileStats", bundle: nil)
        let profileStatsViewController = storyboardProfileStats.instantiateInitialViewController() as! ProfileStatsTableViewController

        profileStatsHeightConstraint.constant = profileStatsViewController.getTableViewHeight()
        
        addChildViewController(profileStatsViewController, toContainerView: profileStatsContainer)
        profileStatsDelegate = profileStatsViewController
        
        
        
        
        
        let storyboardProfileHistory = UIStoryboard(name: "ProfileHistory", bundle: nil)
        let profileHistoryViewController = storyboardProfileHistory.instantiateInitialViewController() as! ProfileHistoryTableViewController
        
        profileHistoryHeightConstraint.constant = profileHistoryViewController.getTableViewHeight()
        
        addChildViewController(profileHistoryViewController, toContainerView: profileHistoryContainer)
        profileHistoryDelegate = profileHistoryViewController
        
    }
}

/*
    // MARK: - Setup
    
    func embedProfileAvatar() {
        let storyboardProfileImage = UIStoryboard(name: "ProfileImage", bundle: nil)
        let profileImageViewController = storyboardProfileImage.instantiateInitialViewController() as! ProfileImageViewController
        addChildViewController(profileImageViewController, toContainerView: profileImageContainer)
    }
    
    func embedProfileInformation() {
        let storyboardProfileHistory = UIStoryboard(name: "ProfileHistory", bundle: nil)
        let profileHistoryViewController = storyboardProfileHistory.instantiateInitialViewController() as! ProfileHistoryTableViewController
        addChildViewController(profileHistoryViewController, toContainerView: profileHistoryContainer)
        profileHistoryDelegate = profileHistoryViewController
        
        let storyboardProfileStats = UIStoryboard(name: "ProfileStats", bundle: nil)
        let profileStatsViewController = storyboardProfileStats.instantiateInitialViewController() as! ProfileStatsTableViewController
        addChildViewController(profileStatsViewController, toContainerView: profileStatsContainer)
        profileStatsDelegate = profileStatsViewController
    }
    
    
    // MARK: Profile
    
    func getLoginInformation() {
        if getLoggedInUser() {
            createNavbarButton("Logout", action: "pressedLogoutNavbarButton:", isLeftButton: false)
            createNavbarButton("Change PW", action: "pressedChangePWNavbarButton:", isLeftButton: true)
        } else {
            createNavbarButton("Login/Signup", action: "pressedLoginNavbarButton:", isLeftButton: false)
        }
    }
    
    func getLoggedInUser() -> Bool {
        
        if let user = UserAccess.sharedInstance.getUser() {
            self.userName = user.username
            self.token = user.token
            embedProfileInformation()
            scrollView.scrollEnabled = true
            
            return true
        }
        return false
    }
    
    func fetchUserInformation() {
        ApiProxy().fetchUserAccountInformation({ (userAccount) -> () in
            self.profileStatsDelegate?.userDataWasRefreshed(self, userAccount: userAccount)
            self.profileHistoryDelegate?.userDataWasRefreshed(self, userAccount: userAccount)
            
        }) { (errorCode) -> () in
            if errorCode != "NotLoggedIn" {self.displayAlert(errorCode)}
                
        }
    }
    
    
    // MARK: - NavBar
    
    func createNavbarButton(buttonTitle: String, action: String, isLeftButton: Bool) {
        let logoutNavbarItem = UIBarButtonItem(title: buttonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(action))
        logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        if isLeftButton {
            self.navigationItem.leftBarButtonItem = logoutNavbarItem
        } else {
            self.navigationItem.rightBarButtonItem = logoutNavbarItem
        }
    }
    
    func pressedLogoutNavbarButton(sender: UIBarButtonItem) {
        if let newToken = UserAccess.sharedInstance.getUser()?.token {
            
            ApiProxy().deleteThisUserToken(newToken, success: { () -> () in
                UserAccess.sharedInstance.deleteAllUsers()
                self.navigatoToWelcomeViewController()
                
            }) { (errorCode) -> () in
                self.displayAlert(errorCode)
                
            }
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToWelcomeViewController()
    }
    
    func pressedChangePWNavbarButton(sender: UIBarButtonItem) {
        performSegueWithIdentifier("toChangePasswordViewController", sender: self)
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == "embedProfileStatsTableViewController") || (identifier == "embedProfileHistoryTableViewController") {
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier {
            
            switch (identifier) {
                
            case "embedProfileStatsTableViewController":
                let destinationVC = segue.destinationViewController as! ProfileStatsTableViewController
                self.profileStatsDelegate = destinationVC
                
            case "embedProfileHistoryTableViewController":
                let destinationVC = segue.destinationViewController as! ProfileHistoryTableViewController
                self.profileHistoryDelegate = destinationVC
                
            case "toProfileCollectionView":
                let destinationVC = segue.destinationViewController as! ProfileCollectionViewController
                destinationVC.downloadUserCreatedPosts = true // put guard here
                destinationVC.userAccount = sender as! UserAccount
                
            case "toUserChallenges":
                let destinationVC = segue.destinationViewController as! MyChallengeViewController
                destinationVC.userAccount = sender as! UserAccount // put guard here
                
            case "toWonChallenges":
                let destinationVC = segue.destinationViewController as! MyChallengeViewController
                destinationVC.userAccount = sender as! UserAccount // put guard here
                destinationVC.wonChallenges = true
                
            case "toLikedPosts":
                let destinationVC = segue.destinationViewController as! ProfileCollectionViewController
                destinationVC.downloadUserCreatedPosts = false
                destinationVC.userAccount = sender as! UserAccount
                
            default:
                break
            }
        }
    }
    
    func navigatoToWelcomeViewController() {
        
        dispatch_async(dispatch_get_main_queue()) {
            if (UIApplication.sharedApplication().delegate as! AppDelegate).welcomeViewController != nil {
                self.performSegueWithIdentifier("unwindToWelcomeViewController", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewControllerWithIdentifier("WelcomeViewController")
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {}
}
 
 */

//
//  ProfileViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageContainer: UIView!
    @IBOutlet weak var profileStatsContainer: UIView!
    @IBOutlet weak var profileHistoryContainer: UIView!
    
    
    @IBOutlet weak var profileImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileStatsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileHistoryHeightConstraint: NSLayoutConstraint!
    
    var userName: String?
    var token: String?
    var loadedDataTimestamp: NSDate?
    var profileStatsDelegate: ProfileViewControllerDelegate?
    var profileHistoryDelegate: ProfileViewControllerDelegate?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)

        getLoginInformation()
        
        
        
//        addDefaultPullToRefresh(scrollView, selector: "fetchUserInformation")
        
        
//        let url = "\(ServerAccess.sharedInstance.getServer()!.serverAddress)/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
//        SDWebImageManager.sharedManager().imageDownloader.setValue("Bearer \(UserAccess.sharedInstance.getUser()!.token)", forHTTPHeaderField: "Authorization")
//        profileImageView.sd_setImageWithURL(<#T##url: NSURL!##NSURL!#>)
//        
//        
//        
//        cell.postImage.sd_setImageWithURL(NSURL(string: url))
        
        
        
        
        
    }
    
    
    // MARK: - Setup
    

    
    override func viewWillAppear(animated: Bool) {
        fetchUserInformation()
    }
    
    func embedProfileInformation() {
        let profileImageViewController = UIStoryboard(name: "ProfileImage", bundle: nil).instantiateInitialViewController() as! ProfileImageViewController
        profileImageHeightConstraint.constant = profileImageViewController.getViewHeight()
        addChildViewController(profileImageViewController, toContainerView: profileImageContainer)
        // delegate?
        
        let profileStatsViewController = UIStoryboard(name: "ProfileStats", bundle: nil).instantiateInitialViewController() as! ProfileStatsTableViewController
        profileStatsHeightConstraint.constant = profileStatsViewController.getTableViewHeight()
        addChildViewController(profileStatsViewController, toContainerView: profileStatsContainer)
        profileStatsDelegate = profileStatsViewController
        
        let profileHistoryViewController = UIStoryboard(name: "ProfileHistory", bundle: nil).instantiateInitialViewController() as! ProfileHistoryTableViewController
        profileHistoryHeightConstraint.constant = profileHistoryViewController.getTableViewHeight()
        addChildViewController(profileHistoryViewController, toContainerView: profileHistoryContainer)
        profileHistoryDelegate = profileHistoryViewController
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
    
    
    // MARK: - NavigationBar
    
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
        ApiProxy().deleteThisUserToken({ () -> () in
            UserAccess.sharedInstance.deleteAllUsers()
            self.navigatoToWelcomeViewController()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToWelcomeViewController()
    }
    
    func pressedChangePWNavbarButton(sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let authenticationVC = storyboard.instantiateViewControllerWithIdentifier("ChangePasswordViewController") as! ChangePasswordViewController
        
        
        self.navigationController?.presentViewController(authenticationVC, animated: true, completion: nil)
        
//        self.presentViewController(authenticationVC, animated: true, completion: {() -> Void in
//            authenticationVC.view.setNeedsDisplay()
//            authenticationVC.view.layoutIfNeeded()
//        })
    }
    
    
    // MARK: - Navigation
    
    func navigatoToWelcomeViewController() {
        
        dispatch_async(dispatch_get_main_queue()) {
            if (UIApplication.sharedApplication().delegate as! AppDelegate).welcomeViewController != nil {
                self.performSegueWithIdentifier("unwindToWelcomeViewController", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
                let loginVC = storyboard.instantiateInitialViewController() as! WelcomeViewController
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
    }
    
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
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {}
}





//
//  ProfilViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfilViewController, userAccount: UserAccount)
    
}






class ProfilViewController: UIViewController {

    var profileStatsDelegate: ProfileViewControllerDelegate?
    var profileHistoryDelegate: ProfileViewControllerDelegate?
    
    var userName: String?
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if getLoggedInUser() {
            performSegueWithIdentifier("embedProfileStatsTableViewController", sender: self)
            performSegueWithIdentifier("embedProfileHistoryTableViewController", sender: self)
            createNavbarButton("Logout", action: "pressedLogoutNavbarButton:")
        } else {
            createNavbarButton("Login/Signup", action: "pressedLoginNavbarButton:")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchUserInformation()
    }

    
    
    // MARK: - Profile
    
    func getLoggedInUser() -> Bool {
        
        if let user = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            if let userName = user.username, let token = user.token {
                self.userName = userName
                self.token = token
                
                return true
            }
        }
        return false
    }
    
    func fetchUserInformation() {
        
        ApiProxy().fetchUserAccountInformation({ (userAccount) -> () in
            
            self.profileStatsDelegate?.userDataWasRefreshed(self, userAccount: userAccount)
            
            
            //self.userAccount = userAccount
//            self.displayUserLabel(userAccount.username)
//            self.displayUserProfileImage(userAccount.username)
//            self.displayUserTableView()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            // self.displaySignupInformation()
                
        }
    }
    
    
    // MARK: - NavBar
    
    func createNavbarButton(buttonTitle: String, action: String) {
        let logoutNavbarItem = UIBarButtonItem(title: buttonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(action))
        logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = logoutNavbarItem
    }
    
    func pressedLogoutNavbarButton(sender: UIBarButtonItem) {
        
        ApiProxy().deleteThisUserToken(token!, success: { () -> () in
            User.removeUserToken(AppDelegate().managedObjectContext)
            self.navigatoToLoginViewController()
            
            }) { (errorCode) -> () in
                self.displayAlert(errorCode)
                
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToLoginViewController()
    }
    
    
    // MARK: - Navigation
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "embedProfileStatsTableViewController" {
            return false
        }
        if identifier == "embedProfileHistoryTableViewController" {
            return false
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "embedProfileStatsTableViewController" {
            let destinationVC = segue.destinationViewController as! ProfileStatsTableViewController
            self.profileStatsDelegate = destinationVC
        }
//        if segue.identifier == "embedProfileHistoryTableViewController" {
//            let destinationVC = segue.destinationViewController as! ProfileHistoryTableViewController
//            self.profileHistoryDelegate = destinationVC
//        }
    }
    
    func navigatoToLoginViewController() {
        
        dispatch_async(dispatch_get_main_queue()) {
            if (UIApplication.sharedApplication().delegate as! AppDelegate).loginViewController != nil {
                self.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {}

}

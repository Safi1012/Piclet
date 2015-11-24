//
//  ProfileViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 06/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logutNavbarButton: UIBarButtonItem!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var token: String?
    var userName: String?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        styleProfileButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchLoggedInUser()
        updateUserUI()
    }
    
    func fetchLoggedInUser() {
        if let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            if let userToken = loggedInUser.token, let userName = loggedInUser.username {
                self.token = userToken
                self.userName = userName
            }
        }
    }
    
    func updateUserUI() {
        if let userName = self.userName, let token = self.token {
            refreshUserProfileImage(userName)
            createNavbarButton("Logout", action: "pressedLogoutNavbarButton:")
        } else {
            createNavbarButton("Login/Signup", action: "pressedLoginNavbarButton:")
        }
    }
    

    
    // MARK: - UI
    
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
    
    func styleProfileButton() {
        userProfileButton.layer.backgroundColor = UIColor.clearColor().CGColor
        userProfileButton.layer.cornerRadius = userProfileButton.frame.width / 2.0
        userProfileButton.layer.masksToBounds = true
    }
    
    
    // needs to be tested
    func refreshUserProfileImage(username: String) {
        let url = NSURL(string: "https://piclet.de/users/\(username)/avatar-medium.jpeg")
        userProfileButton.imageView!.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userProfileRoundPlacholder"))
    }
    
    @IBAction func userPressedProfileImage(sender: UIButton) {
        
        
        
        
    }

    
    
    
    
    
    
    // MARK: - Navigation
    
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
}

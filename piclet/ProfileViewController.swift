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
    
    var loggedInUser: User?
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let loggedInUser = User.getLoggedInUser(managedObjectContext) {
            createLogoutNavbarButton()
            self.loggedInUser = loggedInUser
        } else {
            createLoginNavbarButon()
        }
    }
    

    
    // MARK: - UI
    
    func displayAlert(alertController: UIAlertController) {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func createLogoutNavbarButton() {
        let logoutNavbarItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "pressedLogoutNavbarButton:")
            logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = logoutNavbarItem
    }
    
    func createLoginNavbarButon() {
        let logoutNavbarItem = UIBarButtonItem(title: "Login/Signup", style: UIBarButtonItemStyle.Plain, target: self, action: "pressedLoginNavbarButton:")
        logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = logoutNavbarItem
    }
    
    func pressedLogoutNavbarButton(sender: UIBarButtonItem) {
        
        ApiProxy().deleteToken(loggedInUser!.token!, success: { () -> () in
            
            User.updateUserToken(self.managedObjectContext, user: self.loggedInUser!, newToken: nil)
            self.navigatoToLoginViewController()
            
        }) { (errorCode) -> () in
            
            self.displayAlert(UIAlertController.createErrorAlert(errorCode))
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToLoginViewController()
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

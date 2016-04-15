//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    
    var thirdPartySignInService = ThirdPartySignInService.username
    var oauthToken: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        googleButton.addBoarderTop()
        usernameButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
        thirdPartySignInService = ThirdPartySignInService.google
        GIDSignIn.sharedInstance().signOut()    // remove later
        GIDSignIn.sharedInstance().signIn()
        
        
//        thirdPartySignInService = ThirdPartySignInService.google
//        loadTermsOfServiceViewController()
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
        thirdPartySignInService = ThirdPartySignInService.username
        // perfrom segue to userVC
    }
    
    
    // MARK: - SignIn / SignUp
    
    func loadThirdPartySignInService() {
        switch thirdPartySignInService {
            
        case .facebook:
            break
            
        case .google:
            break
            
            
        default:
            break
        }
    }

    func signInInPiclet(jwt: String) {
        ApiProxy().signInUserWithThirdPartyService(jwt, tokenType: TokenType.google, success: {
            self.performSegueWithIdentifier("toChallengesViewController", sender: self)
            
        }) { (errorCode) in
            if errorCode == "UsernameNotFoundError" {
                self.loadTermsOfServiceViewController()
            } else {
                self.displayAlert(errorCode)
            }
        }
    }

    
    // MARK: - Navigation
    
    func loadTermsOfServiceViewController() {
        let tosViewController = TosViewController(nibName: "TosViewController", bundle: NSBundle.mainBundle())
        addChildViewController(tosViewController, toContainerView: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toThirdPartyServiceViewController" {
            removeLastChildViewController(self)
            let thirdPartyViewController = segue.destinationViewController as! ThirdPartyServiceViewController
            
            thirdPartyViewController.oauthToken = oauthToken!
            thirdPartyViewController.thirdPartySignInService = thirdPartySignInService
        }
    }
    
    @IBAction func unwindToWelcomeViewController(segue: UIStoryboardSegue) {}
}


// MARK: - GIDSignInDelegate

extension WelcomeViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if (error == nil) {
            oauthToken = user.authentication.idToken
            signInInPiclet(user.authentication.idToken)
        } else {
            removeLastChildViewController(self)
        }
    }
}


// MARK: - Enum - ThirdPartySignInService

enum ThirdPartySignInService {
    case facebook
    case google
    case username
}



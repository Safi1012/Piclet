//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var setupServerButton: UIButton!
    
    
    // var thirdPartySignInService = ThirdPartySignInService.username
    var oauthToken: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // todo: check if app was opened for the first time
        // showOnboarding()
        
        uiStyling()
        
        // Google SignIn Service setup
        // GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().delegate = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        signInButton.addBoarderTop()
        setupServerButton.addBoarderTop()
        setupServerButton.addBoarderBottom()
    }
    
}
/*
    
    
    // MARK: - Onboarding
    
    func showOnboarding() {
        // let page0 = EAIntroPage()
        // page0.title = "Welcome to Piclet"
        // page0.titlePositionY = 30.0
        // page0.desc = "Start sharing your Pictures and particacipate \n in competive challeneges."
        // page0.descPositionY = 100.0
        // page0.titleIconPositionY = 100.0
        // page0.titleIconView = UIImageView(image: UIImage(named: "picletIcon"))
        
        // build pages
        let page0 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_0", bundle: NSBundle.mainBundle())
        let page1 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_1", bundle: NSBundle.mainBundle())
        let page2 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_2", bundle: NSBundle.mainBundle())
        
        // create introduction view
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page0, page1, page2])
        intro.bgImage = UIImage(named: "backgroundLogin")
        // intro.delegate = self
        
        // display introduction view
        intro.showInView(self.view, animateDuration: 0.0)
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        googleButton.addBoarderTop()
        usernameButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
        thirdPartySignInService = ThirdPartySignInService.google
        GIDSignIn.sharedInstance().signOut()    // remove later
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
        thirdPartySignInService = ThirdPartySignInService.username
        performSegueWithIdentifier("toUserViewController", sender: self)
    }
    
    @IBAction func pressedSkipButton(sender: AnyObject) {
        performSegueWithIdentifier("toChallengesViewController", sender: self)
    }
    
    
    // MARK: - SignIn / SignUp

    func signInInPiclet(jwt: String) {
        ApiProxy().signInUserWithThirdPartyService(jwt, tokenType: TokenType.google, success: { () in
            self.performSegueWithIdentifier("toChallengesViewController", sender: self)
            
        }) { (errorCode) in
            if errorCode == "UsernameNotFoundError" {
                self.performSegueWithIdentifier("toThirdPartyServiceViewController", sender: self)
            } else {
                self.displayAlert(errorCode)
            }
        }
    }

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toThirdPartyServiceViewController" {
            let thirdPartyServiceViewController = segue.destinationViewController as? ThirdPartyServiceViewController
            thirdPartyServiceViewController?.oauthToken = oauthToken
            thirdPartyServiceViewController?.thirdPartySignInService = thirdPartySignInService
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
            print("\(error.description)")
        }
    }
}


// MARK: - Enum - ThirdPartySignInService

enum ThirdPartySignInService {
    case facebook
    case google
    case username
}

*/

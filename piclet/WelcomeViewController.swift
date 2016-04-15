//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit
import FBSDKLoginKit


class WelcomeViewController: UIViewController, GIDSignInUIDelegate {
    
    // @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var facebookButton: FBSDKLoginButton!
    
    var selectedService = SignInService.username
    var oauthToken: String?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.addBoarderTop()
        googleButton.addBoarderTop()
        usernameButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedFacebookButton(sender: UIButton) {
        selectedService = SignInService.facebook
        loadTermsOfServiceViewController()
    }
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
        selectedService = SignInService.google
        loadTermsOfServiceViewController()
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
        selectedService = SignInService.username
        
        // perfrom segue to userVC
    }
    
    
    // MARK: - SignIn / SignUp

    func signInInPiclet(jwt: String) {
        ApiProxy().signInUserWithThirdPartyService(jwt, tokenType: TokenType.google, success: {
            self.performSegueWithIdentifier("toChallengesViewController", sender: self)
            
        }) { (errorCode) in
            if errorCode == "UsernameNotFoundError" {
                // self.parseOauthtokenForSuggestion(jwt)
                self.performSegueWithIdentifier("toThirdPartyServiceViewController", sender: self)
                
            } else {
                self.displayAlert(errorCode)
            }
        }
    }
    
    func parseOauthtokenForSuggestion(jwt: String) -> String {
        let username = JWTParser().suggestUsernameFromJWT(jwt)
        
        if username.characters.count > 0 {
            return username
        } else {
            return "Username"
        }
    }
    
    
    
    
    
    // MARK: - Navigation
    
    func loadTermsOfServiceViewController() {
        let tosViewController = TosViewController(nibName: "TosViewController", bundle: NSBundle.mainBundle())
        addChildViewController(tosViewController, toContainerView: view)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toThirdPartyServiceViewController" {
            let thirdPartyViewController = segue.destinationViewController as! ThirdPartyServiceViewController
            thirdPartyViewController.oauthToken = oauthToken!
        }
    }
    

    
    
    
    
    func navigateToSelectedServiceViewController() {
        // removeLastChildViewController(self)
        
        switch selectedService {
            
        case .facebook:
            
            facebookButton.delegate = self
            let fbLoginManager = FBSDKLoginManager()
            
            if (FBSDKAccessToken.currentAccessToken() != nil) {
                // User is logged in, do work such as go to next view controller.
                
                print("\(FBSDKAccessToken.currentAccessToken().tokenString)")
                print("User already logged in")
            }
            
            fbLoginManager.logOut()
            
            
            fbLoginManager.logInWithReadPermissions(["public_profile", "email"], fromViewController: self, handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) in
                print("done")
                
                if (error != nil) {
                    print("process Error")
                } else if result.isCancelled {
                    print("Get called, when the user pressed Done in the top left corner")
                } else {
                    print("logged In")
                }
                
            })

            
        case .google:
            removeLastChildViewController(self)
            
            GIDSignIn.sharedInstance().uiDelegate = self
            GIDSignIn.sharedInstance().delegate = self
            GIDSignIn.sharedInstance().signOut()
            GIDSignIn.sharedInstance().signIn()
            
        case .username:
            performSegueWithIdentifier("toUserViewController", sender: self)
        }
    }
}


// MARK: - FBSDKLoginButtonDelegate

extension WelcomeViewController: FBSDKLoginButtonDelegate {
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("done?")
        print("\(result.token.tokenString)")
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("done?")
    }
    
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}


extension WelcomeViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if (error == nil) {
            oauthToken = user.authentication.idToken
            // signInInPiclet(user.authentication.idToken)
        } else {
            print("\(error.localizedDescription)")
            
            // self.displayParentViewController()
            // maye add check internet connectivity
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        // later remove token from Realm
    }
}

enum SignInService {
    case facebook
    case google
    case username
}



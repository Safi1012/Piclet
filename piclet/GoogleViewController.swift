//
//  GoogleViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class GoogleViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    var oauthtoken: String?
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.hidden = true
    
        // Instantiate Google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()            // remove, after testing
    }
    
    override func viewDidAppear(animated: Bool) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - Stying
    
    func uiStyling() {
        usernameTextField.changePlaceholderColoring(UIColor.lightTextColor())
        usernameTextField.addBottomBorder(UIColor.whiteColor())
        doneButton.addRoundButtonBorder()
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedDoneButton(sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let oauthtoken = oauthtoken
        else {
            print("username or oatuhtoken is nil!")
            return
        }
        signUpUserWithThirdPartyService(username, oauthtoken: oauthtoken)
    }
    
    func navigateToChallenges() {
        if let thirdPartService = parentViewController as? ThirdPartyServiceViewController {
            thirdPartService.navigateToChallengeViewController()
        }
    }
    
    
    // MARK: Signup
    
    func isUserAlreadySignedUp(jwt: String) {
        ApiProxy().signInUserWithThirdPartyService(jwt, tokenType: TokenType.google, success: {
            self.navigateToChallenges()
            
        }) { (errorCode) in
            if errorCode == "UsernameNotFoundError" {
                self.parseOauthtokenForSuggestion(jwt)
            } else {
                self.displayAlert(errorCode)
            }
        }
    }
    
    func parseOauthtokenForSuggestion(jwt: String) {
        let username = JWTParser().suggestUsernameFromJWT(jwt)
        
        if username.characters.count > 0 {
            usernameTextField.text = username
        } else {
            usernameTextField.text = "Username"
        }
    }
    
    func signUpUserWithThirdPartyService(username: String, oauthtoken: String) {
        ApiProxy().createUserWithThirdPartyService(username, oauthToken: oauthtoken, tokenType: TokenType.google, success: {
            self.navigateToChallenges()
            
        }) { (errorCode) in
            self.displayAlert(errorCode)
            
        }
    }
}


// MARK: - GIDSignInDelegate

extension GoogleViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        view.hidden = false
        
        if (error == nil) {
            isUserAlreadySignedUp(user.authentication.idToken)
        } else {
            print("\(error.localizedDescription)")
            
            // self.displayParentViewController()
            // maye add check internet connectivity
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        // later remove token from Realm
        
        print("TEST")
    }
}
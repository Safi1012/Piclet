//
//  GoogleViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class GoogleViewController: UIViewController, GIDSignInUIDelegate {
    
    var oauthtoken: String?
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Instantiate Google
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()            // remove, after testing
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    // MARK: - UI
    
    
    
    // MARK: Signup
    
    func isUserAlreadySignedUp(jwt: String) {
        
        ApiProxy().signInUserWithThirdPartyService(jwt, tokenType: TokenType.google, success: {
            print("success")
            
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
            // userinput with username as placeholder
        } else {
            
        }
    }
    
    func signUpUserWithThirdPartyService(oauthtoken: String) {
        // create user account
        
    }
}


// MARK: - GIDSignInDelegate

extension GoogleViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            isUserAlreadySignedUp(user.authentication.idToken)
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        // later remove token from Realm
    }
}
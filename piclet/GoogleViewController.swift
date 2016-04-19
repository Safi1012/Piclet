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
    }
    
    override func viewDidAppear(animated: Bool) {
        GIDSignIn.sharedInstance().signIn()
    }
}


// MARK: - GIDSignInDelegate

extension GoogleViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        view.hidden = false
        
        if (error == nil) {
            // isUserAlreadySignedUp(user.authentication.idToken)
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
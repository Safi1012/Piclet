//
//  ThirdPartyServiceViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ThirdPartyServiceViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    var thirdPartyService: SignInService! // delete?
    var oauthToken: String!
    var username: String?
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedDone(sender: UIButton) {
        switch thirdPartyService! {
        
        case .facebook:
            print("fb")
        
        case .google:
            signUpInPiclet()
        
        default:
            break
        }
    }
    
    
    // MARK: - SignIn / SignUp
    
    func signUpInPiclet() {
        
        guard
            let username = usernameTextField.text,
            let oauthToken = oauthToken
        else {
            print("username or oatuhtoken is nil!")
            return
        }
        
        ApiProxy().createUserWithThirdPartyService(username, oauthToken: oauthToken, tokenType: TokenType.google, success: {
            self.navigateToChallengeViewController()

        }) { (errorCode) in
            self.displayAlert(errorCode)

        }
    }
    
    
    // MARK: - Navigation
    
    func navigateToChallengeViewController() {
        performSegueWithIdentifier("toChallengesViewController", sender: self)
    }
}




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
    @IBOutlet weak var doneButton: UIButton!
    var thirdPartySignInService: ThirdPartySignInService! // delete?
    var oauthToken: String!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        parseOauthtokenForSuggestion(oauthToken)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        usernameTextField.changePlaceholderColoring(UIColor.lightTextColor())
        usernameTextField.addBottomBorder(UIColor.whiteColor())
        doneButton.addRoundButtonBorder()
    }
    
    @IBAction func pressedDone(sender: UIButton) {
        switch thirdPartySignInService! {
        
        case .facebook:
            print("fb")
        
        case .google:
            signUpInPiclet()
        
        default:
            break
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
    
    @IBAction func pressedCancel(sender: UIButton) {
        // performSegueWithIdentifier("", sender: self)
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




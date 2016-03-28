//
//  UsernameViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 28/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class UsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!

    var thirdPartyToken: String!
    var tokenType: TokenType!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: UI
    
    func uiStyling() {
        usernameTextField.changePlaceholderColoring(UIColor.lightTextColor())
        usernameTextField.addBottomBorder(UIColor.whiteColor())
    }
    
    @IBAction func pressedCreateAccount(sender: UIButton) {
        if validateTextFields() {
            signupUser(usernameTextField.text!)
        }
    }
    
    @IBAction func pressedCancelSignUp(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: SignIn
    
    func signupUser(username: String) {
        showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 0.0), color: UIColor.whiteColor())
        
        ApiProxy().signInUserWithThirdPartyService(username, oauthToken: thirdPartyToken, tokenType: tokenType, success: {
            self.dismissLoadingSpinner()
            self.navigateToChallengesViewController()
            
        }) { (errorCode) in
            self.dismissLoadingSpinner()
            self.displayAlert(errorCode)
            
        }
    }
    
    func validateTextFields() -> Bool {
        if (!UserDataValidator().isUsernameLongEnough(usernameTextField.text!)) {
            self.displayAlert("UsernameTooShort")
            return false
        }
        if (UserDataValidator().containsSpecialCharacters(usernameTextField.text!)) {
            self.displayAlert("UsernameWrongCharacters")
            return false
        }
        return true
    }
    
    
    // MARK: Navigation
    
    func navigateToChallengesViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ChallengeProfile") as! TabBarViewController
        
        presentViewController(tabBarViewController, animated: true, completion: nil)
    }
}

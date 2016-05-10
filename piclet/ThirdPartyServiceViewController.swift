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
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var thirdPartySignInService: ThirdPartySignInService!
    var oauthToken: String!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        
        parseOauthtokenForSuggestion(oauthToken)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ThirdPartyServiceViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ThirdPartyServiceViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        usernameTextField.changePlaceholderColoring(UIColor.lightTextColor())
        usernameTextField.addBottomBorder(UIColor.whiteColor())
        createAccountButton.addRoundButtonBorder()
    }
    
    @IBAction func pressedCreateAccount(sender: UIButton) {
        switch thirdPartySignInService! {
        
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

    
    // MARK: - SignIn / SignUp
    
    func signUpInPiclet() {
        
        guard
            let username = usernameTextField.text,
            let oauthToken = oauthToken
        else {
            print("username or oauthToken is nil!")
            return
        }
        
        ApiProxy().createUserWithThirdPartyService(username, oauthToken: oauthToken, tokenType: TokenType.google, success: {
            AppDelegate().logUser(username)
            self.navigateToChallengeViewController()

        }) { (errorCode) in
            self.displayAlert(errorCode)

        }
    }
    
    
    // MARK: - Navigation
    
    func navigateToChallengeViewController() {
        performSegueWithIdentifier("toChallengesViewController", sender: self)
    }

    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let kbSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height + 60.0, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        if !CGRectContainsPoint(aRect, createAccountButton.frame.origin) {
            scrollView.scrollRectToVisible(createAccountButton.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -self.scrollView.contentInset.top), animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension ThirdPartyServiceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            usernameTextField.becomeFirstResponder()
            signUpInPiclet()
        }
        return true
    }
}




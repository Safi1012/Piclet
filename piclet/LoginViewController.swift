//
//  LoginViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var googleSigninButton: GIDSignInButton!
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        AppDelegate().loginViewController = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        // Google SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signOut()            // remove, after testing
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - Stying
    
    func uiStyling() {
        usernameTextField.changePlaceholderColoring(UIColor.lightTextColor())
        passwordTextField.changePlaceholderColoring(UIColor.lightTextColor())
        
        usernameTextField.addBottomBorder(UIColor.whiteColor())
        passwordTextField.addBottomBorder(UIColor.whiteColor())
        
        loginButton.addRoundButtonBorder()
    }
    
    
    // MARK: - Login
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        if validateTextFields() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0), color: UIColor.whiteColor())

            ApiProxy().createUserAccount(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.dismissLoadingSpinner()
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.dismissLoadingSpinner()
                self.displayAlert(errorCode)
                
            })
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        performLogin()
    }
    
    func performLogin() {
        if validateTextFields() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0), color: UIColor.whiteColor())
                        
            ApiProxy().signInUser(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.dismissLoadingSpinner()
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.dismissLoadingSpinner()
                self.displayAlert(errorCode)
                
            })
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
        if (!UserDataValidator().isPasswordLongEnough(passwordTextField.text!)) {
            self.displayAlert("PasswordTooShort")
            return false
        }
        return true
    }

    
    // MARK: - Navigation
    
    @IBAction func skipButtonPressed(sender: UIButton) {
        navigateToChallengesViewController()
    }
    
    func navigateToChallengesViewController() {
        self.performSegueWithIdentifier("toChallengesViewController", sender: self)
    }
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {}
    
    
    // MARK: - Keyboard 
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let kbSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        if !CGRectContainsPoint(aRect, signupButton.frame.origin) {
            scrollView.scrollRectToVisible(signupButton.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -self.scrollView.contentInset.top), animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
            performLogin()
        }
        return true
    }
}


// MARK: - GIDSignInDelegate

extension LoginViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        
        if (error == nil) {
            let storyboardProfileImage = UIStoryboard(name: "Username", bundle: nil)
            let usernameViewController = storyboardProfileImage.instantiateInitialViewController() as! UsernameViewController
            usernameViewController.thirdPartyToken = user.authentication.idToken
            usernameViewController.tokenType = TokenType.google
            
            presentViewController(usernameViewController, animated: false, completion: nil)
            
        } else {
            print("\(error.localizedDescription)")
            
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        print("User Disconnected - Google SignIn")
    }
}


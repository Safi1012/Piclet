//
//  LoginViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet weak var googleSigninButton: GIDSignInButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        AppDelegate().loginViewController = self
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
    
        // Google SignIn
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        googleSigninButton.colorScheme = .Light
        googleSigninButton.style = .Standard
        
        GIDSignIn.sharedInstance().signOut()
        googleSigninButton.addTarget(self, action: #selector(LoginViewController.googleSignInButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - Stying
    
    func uiStyling() {
        placeholderColoring()
        bottomBorderStyling(usernameTextField)
        bottomBorderStyling(passwordTextField)
        addLoginButtonBorder()
    }
    
    func bottomBorderStyling(textField: UITextField) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, usernameTextField.frame.size.height - 1, usernameTextField.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.whiteColor().CGColor
        textField.layer.addSublayer(bottomBorder)
    }
    
    func placeholderColoring() {
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.lightTextColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.lightTextColor()])
    }
    
    func addLoginButtonBorder() {
        loginButton.layer.borderWidth = 1.0
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.cornerRadius = 5.0
        loginButton.layer.masksToBounds = true
    }
    
    
    // MARK: - Login
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        if validateTextFields() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0))

            ApiProxy().createUserAccount(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                
            })
        }
    }
    @IBAction func googleSignInButtonPressed(sender: GIDSignInButton) {
        print("TEST")
        // GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        performLogin()
    }
    
    func performLogin() {
        if validateTextFields() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0))
                        
            ApiProxy().signInUser(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                self.dismissLoadingSpinner()
            
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                self.dismissLoadingSpinner()
                
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
        dispatch_async(dispatch_get_main_queue()) {
            self.performSegueWithIdentifier("toChallengesViewController", sender: self)
        }
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


// MARK: - GIDSignInUIDelegate

extension LoginViewController: GIDSignInUIDelegate {
    
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        self.dismissLoadingSpinner()
    }
    
    func signIn(signIn: GIDSignIn!, presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func signIn(signIn: GIDSignIn!, dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


// MARK: - GIDSignInDelegate

extension LoginViewController: GIDSignInDelegate {
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if (error == nil) {
            let userId = user.userID                  // For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let name = user.profile.name
            let email = user.profile.email

            // call new View to choose the username
            
            // call Joahannes API -> to generate API key
            
        } else {
            print("\(error.localizedDescription)")
        }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!, withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        print("TEST")
    }
}


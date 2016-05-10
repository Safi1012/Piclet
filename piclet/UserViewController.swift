//
//  UserViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation

class UserViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    
    var userAcceptedTos = false
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
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
        
        signInButton.addRoundButtonBorder()
    }
    
    
    // MARK: - UI
    
    @IBAction func signUpButtonPressed(sender: UIButton) {
        if validateTextFields() {
            signUpUser()
        }
    }
    
    @IBAction func signInButtonPressed(sender: UIButton) {
        signInUser()
    }
    
    
    // MARK: - SignIn / SignUp
    
    func signUpUser() {
        showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0), color: UIColor.whiteColor())
        
        ApiProxy().createUserAccount(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
            AppDelegate().logUser(self.usernameTextField.text!)
            self.dismissLoadingSpinner()
            self.navigateToChallengesViewController()
            
            }, failure: { (errorCode) -> () in
                self.dismissLoadingSpinner()
                self.displayAlert(errorCode)
        })
    }

    func signInUser() {
        if validateTextFields() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 140.0), color: UIColor.whiteColor())
            
            ApiProxy().signInUser(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                AppDelegate().logUser(self.usernameTextField.text!)
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
    
    func dismissTosAndSignUp() {
        removeLastChildViewController(self)
        signUpUser()
    }
    
    
    // MARK: - Navigation
    
    func navigateToChallengesViewController() {
        performSegueWithIdentifier("toChallengesViewController", sender: self)
    }

    
    // MARK: - Keyboard
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let kbSize: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height
        
        if !CGRectContainsPoint(aRect, signUpButton.frame.origin) {
            scrollView.scrollRectToVisible(signUpButton.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -self.scrollView.contentInset.top), animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension UserViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            textField.resignFirstResponder()
            signInUser()
        }
        return true
    }
}

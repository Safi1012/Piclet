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
    @IBOutlet weak var topLogoConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLogoConstraint: NSLayoutConstraint!
    
    
    let userDataValidator = UserDataValidator()
    let objectMapper = ObjectMapper()
    let apiProxy = ApiProxy()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        AppDelegate().loginViewController = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        adaptConstraintsToDisplaySize()
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
    
    func adaptConstraintsToDisplaySize() {
        switch (UIScreen().getDisplayInchSize()) {
            
        case DeviceInchSize.inch_3_5:
            topLogoConstraint.constant = 30.0
            bottomLogoConstraint.constant = 15.0
            
        case DeviceInchSize.inch_4_0:
            topLogoConstraint.constant = 70.0
            bottomLogoConstraint.constant = 20.0
            
        case DeviceInchSize.inch_4_7, DeviceInchSize.inch_5_5:
            topLogoConstraint.constant = 80.0
            bottomLogoConstraint.constant = 40.0
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    // MARK: - Login
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        if validateTextFields() {
            showLoadingSpinnerWithoutMask(UIOffset(horizontal: 0.0, vertical: 140.0))

            apiProxy.createUserAccount(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                
            })
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        performLogin()
    }
    
    func performLogin() {
        if validateTextFields() {
            showLoadingSpinnerWithoutMask(UIOffset(horizontal: 0.0, vertical: 140.0))
                        
            apiProxy.signInUser(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                self.dismissLoadingSpinner()
            
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                self.dismissLoadingSpinner()
                
            })
        }
    }
    
    func validateTextFields() -> Bool {
        if (!userDataValidator.isUsernameLongEnough(usernameTextField.text!)) {
            self.displayAlert("UsernameTooShort")
            return false
        }
        if (userDataValidator.containsSpecialCharacters(usernameTextField.text!)) {
            self.displayAlert("UsernameWrongCharacters")
            return false
        }
        if (!userDataValidator.isPasswordLongEnough(passwordTextField.text!)) {
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




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
    @IBOutlet weak var loadingProgressContainerView: UIView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let userDataValidator = UserDataValidator()
    let objectMapper = ObjectMapper()
    let apiProxy = ApiProxy()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).loginViewController = self
        uiStyling()
    }
    
    
    
    // MARK: - UI
    
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
    
//    func showLoadingSpinner() {
//        dispatch_async(dispatch_get_main_queue(), {
//            let loadingSpinner = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
//            loadingSpinner.labelText = "Loading Data"
//        })
//    }
//    
//    func hideLoadingSpinner() {
//        dispatch_async(dispatch_get_main_queue(), {
//            MBProgressHUD.hideHUDForView(self.view, animated: true)
//        })
//    }
    
//    func displayAlert(alertController: UIAlertController) {
//        dispatch_async(dispatch_get_main_queue(), {
//            self.presentViewController(alertController, animated: true, completion: nil)
//        })
//    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    
    // MARK: - Login
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {
        if validateTextFields() {

            apiProxy.createUserAccount(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                
            })
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        if validateTextFields() {
            
            apiProxy.signInUser(usernameTextField.text!, password: passwordTextField.text!, success: { () -> () in
                self.navigateToChallengesViewController()
                
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                
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

    
    
    // MARK: - Naviation
    
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





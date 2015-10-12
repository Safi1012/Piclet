//
//  LoginViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import CoreData
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
    let loadingProgressViewController = LoadingProgressViewController()
    
    
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
    
    func displayAlert(title: String, message: String) {
        dispatch_async(dispatch_get_main_queue()) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func pinSubviewToSuperview() {
        loadingProgressViewController.view.translatesAutoresizingMaskIntoConstraints = false

        let hConstraint = NSLayoutConstraint.constraintsWithVisualFormat("|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": loadingProgressViewController.view])
        let vConstraint = NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["view": loadingProgressViewController.view])

        loadingProgressContainerView.addConstraints(hConstraint)
        loadingProgressContainerView.addConstraints(vConstraint)
    }
    
    func showLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
            
            self.addChildViewController(self.loadingProgressViewController)
            self.loadingProgressContainerView.addSubview(self.loadingProgressViewController.view)
            self.didMoveToParentViewController(self)
            self.pinSubviewToSuperview()
        }
    }
    
    func hideLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
        
            self.willMoveToParentViewController(nil)
            self.loadingProgressViewController.view.removeFromSuperview()
            self.loadingProgressViewController.removeFromParentViewController()
        }
    }
    
    
    
    // MARK: - Login
    
    @IBAction func createAccountButtonPressed(sender: UIButton) {

        if validateTextFields() {
            showLoadingSpinner()
            
            apiProxy.handleUser(usernameTextField.text!, password: passwordTextField.text!, apiPath: "users", success: { () -> () in
                
                self.hideLoadingSpinner()
                self.navigateToChallengesViewController()
                
            }) { (errorCode) -> () in
                    
                self.hideLoadingSpinner()
                self.displayError(errorCode)
            }
        }
    }
    
    @IBAction func loginButtonPressed(sender: UIButton) {
        
        if validateTextFields() {
            showLoadingSpinner()
            
            apiProxy.handleUser(usernameTextField.text!, password: passwordTextField.text!, apiPath: "tokens", success: { () -> () in
                
                self.hideLoadingSpinner()
                self.navigateToChallengesViewController()
                
            }) { (errorCode) -> () in
                    
                self.hideLoadingSpinner()
                self.displayError(errorCode)
            }
        }
    }
    
    func validateTextFields() -> Bool {
        if (!userDataValidator.isUsernameLongEnough(usernameTextField.text!)) {
            displayAlert("Username invalid", message: "The Username must be at least 4 characters long.")
            return false
        }
        if (userDataValidator.containsSpecialCharacters(usernameTextField.text!)) {
            displayAlert("Username invalid", message: "The Username cannot contain any special characters.")
            return false
        }
        if (!userDataValidator.isPasswordLongEnough(passwordTextField.text!)) {
            displayAlert("Password invalid", message: "The password must be at least 8 characters long.")
            return false
        }
        return true
    }
    
    func displayError(errorCode: String) {
        switch(errorCode) {
            
        case "NetworkError":
            self.displayAlert("No Internet", message: "You are not connected to the internet. Please check your Network settings and try again. Thanks!")
            
        case "UsernameTakenError":
            self.displayAlert("Username is already taken", message: "The username you chose is already taken. Please try a different one.")
            
        case "UsernameNotFound":
            self.displayAlert("Username not found", message: "The username or password you typed does not exists. Please try it again.")
            
        case "WrongPassword":
            self.displayAlert("Wrong Password not found", message: "The username or password you typed does not exists. Please try it again.")
            
        case "ErroneousFields":
            self.displayAlert("Login not found", message: "Could not find the Account. The username or password you typed is wrong. Please try it again.")
            
        default:
            self.displayAlert("Server problem", message: "Our server is currently in maintenance. Plase try it again")
        }
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
    
    @IBAction func unwindToLoginViewController(segue: UIStoryboardSegue) {
        print("BACK again")
    }
}





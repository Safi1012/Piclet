//
//  ChangePasswordViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/05/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
    }

//    override func prefersStatusBarHidden() -> Bool {
//        return true
//    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    
    
    // MARK: - Stying
    
    func uiStyling() {
        newPasswordTextField.changePlaceholderColoring(UIColor.lightTextColor())
        oldPasswordTextField.changePlaceholderColoring(UIColor.lightTextColor())
        
        newPasswordTextField.addBottomBorder(UIColor.whiteColor())
        oldPasswordTextField.addBottomBorder(UIColor.whiteColor())
        
        changePasswordButton.addRoundButtonBorder()
    }
    

    // MARK: - User Interaction
    
    @IBAction func pressedChangePasswordButton(sender: UIButton) {
        changePassword()
    }
    
    func displayPasswordChangedAlert() {
        let alert = UIAlertController(title: "Password changed!", message: "From now on you must sign-in \n with your new password", preferredStyle: .Alert)
        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.performSegueWithIdentifier("unwindToProfileViewController", sender: self)
        })
        alert.addAction(alertAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func pressedCancelButton(sender: UIButton) {
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
    // MARK: - Password handling
    
    func changePassword() {
        if checkIfPasswordIsValid() {
            if let user = UserAccess.sharedInstance.getUser() {
                
                ApiProxy().changePassword(user.token, username: user.username, oldPassword: oldPasswordTextField.text!, newPassword: newPasswordTextField.text!, success: {
                    self.fetchNewToken(user, newPassword: self.newPasswordTextField.text!)
                    self.oldPasswordTextField.resignFirstResponder()
                    self.newPasswordTextField.resignFirstResponder()
                    self.displayPasswordChangedAlert()
                    
                }, failure: { (errorCode) in
                    self.displayAlert(errorCode)
                    
                })
            }
        }
    }
    
    func checkIfPasswordIsValid() -> Bool {
        if !UserDataValidator().isPasswordLongEnough(newPasswordTextField.text!) {
            self.displayAlert("PasswordNewTooShort")
            return false
        }
        return true
    }
    
    func fetchNewToken(user: User, newPassword: String) {
        ApiProxy().signInUser(user.username, password: newPassword, success: {}) { (errorCode) in}
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
        
        if !CGRectContainsPoint(aRect, changePasswordButton.frame.origin) {
            scrollView.scrollRectToVisible(changePasswordButton.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -self.scrollView.contentInset.top), animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension ChangePasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == oldPasswordTextField {
            newPasswordTextField.becomeFirstResponder()
        }
        if textField == newPasswordTextField {
            textField.resignFirstResponder()
            changePassword()
        }
        return true
    }
}



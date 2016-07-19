//
//  SetupServerViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/07/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class SetupServerViewController: UIViewController {

    @IBOutlet weak var serverAddressTextField: UITextField!
    @IBOutlet weak var serverPasswordTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var setupButton: UIButton!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SetupServerViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SetupServerViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        uiStyling()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    // MARK: - User Interaction
    
    @IBAction func pressedSetupButton(sender: UIButton) {
        if validateTextFields() {
            ServerAccess.sharedInstance.addServer(serverAddressTextField.text!, serverPassword: serverPasswordTextField.text!)
            performSegueWithIdentifier("unwindToWelcomeViewController", sender: self)
        }
    }
    
    
    func validateTextFields() -> Bool {
        
        if serverAddressTextField.text!.characters.count == 0 {
            self.displayAlert("ServerAddressEmpty")
            return false
        }
//        if !NetworkHandler().isHostReachable(serverAddressTextField.text!) {
//            self.displayAlert("HostNotReachable")
//            return false
//        }
        if serverPasswordTextField.text!.characters.count == 0 {
            self.displayAlert("PasswordEmpty")
            return false
        }
        return true
    }

    
    // MARK: - Stying
    
    func uiStyling() {
        setupButton.addRoundButtonBorder()
        
        serverAddressTextField.addBottomBorder(UIColor.whiteColor())
        serverPasswordTextField.addBottomBorder(UIColor.whiteColor())
        
        serverAddressTextField.changePlaceholderColoring(UIColor.lightTextColor())
        serverPasswordTextField.changePlaceholderColoring(UIColor.lightTextColor())
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
        
        if !CGRectContainsPoint(aRect, setupButton.frame.origin) {
            scrollView.scrollRectToVisible(setupButton.frame, animated: true)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        scrollView.setContentOffset(CGPoint(x: 0.0, y: -self.scrollView.contentInset.top), animated: true)
    }
}


// MARK: - UITextFieldDelegate

extension SetupServerViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == serverAddressTextField {
            serverPasswordTextField.becomeFirstResponder()
        }
        if textField == serverPasswordTextField {
            textField.resignFirstResponder()
            pressedSetupButton(setupButton)
        }
        return true
    }
}
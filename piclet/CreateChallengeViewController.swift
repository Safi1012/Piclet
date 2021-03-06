//
//  CreateViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 19/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class CreateChallengeViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    var token: String!

    @IBAction func pressedCreateTabBar(sender: UIBarButtonItem) {
        
        if validateTextField() {
            showLoadingSpinner(UIOffset(horizontal: 0.0, vertical: 50.0), color: UIColor.blackColor())
            nameTextField.endEditing(true)
            
            ApiProxy().createNewChallenge(nameTextField.text!, success: { () -> () in
                self.performSegueWithIdentifier("unwindToChallengeViewController", sender: self)
                self.dismissLoadingSpinner()
                
                // Force reload screen on ChallengeViewController
                
            }, failure: { (errorCode) -> () in
                self.displayAlert(errorCode)
                self.dismissLoadingSpinner()
                
            })
        }
    }
    
    func validateTextField() -> Bool {
        guard
            let challengeName = nameTextField.text
        else {
            self.displayAlert("ChallengeNameEmpty")
            return false
        }
        if challengeName.characters.count == 0 {
            self.displayAlert("ChallengeNameEmpty")
            return false
        }
        if UserDataValidator().challengeNameContainsOnlyBlankCharacters(challengeName) {
            self.displayAlert("ChallengeNameOnlyBlankCharacters")
            return false
        }
        return true
    }
}


// MARK: - UITextFieldDelegate

extension CreateChallengeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
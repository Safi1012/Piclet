//
//  CreateViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 19/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    override func viewDidLoad() {
        super.viewDidLoad()

        // styleCreateButton()
        nameTextField.delegate = self
    }
    
    func styleCreateButton() {
        createButton.layer.borderWidth = 1.0
        createButton.layer.borderColor = UIColor.whiteColor().CGColor
        createButton.layer.cornerRadius = 5.0
        createButton.layer.masksToBounds = true
    }

    @IBAction func pressedCreateTabBar(sender: UIBarButtonItem) {
        
        guard
            let loggedInUser = User.getLoggedInUser(managedObjectContext),
            let token = loggedInUser.token
        else {
            self.displayAlert("NotLoggedIn")
            return
        }
        
        if validateTextField() {
            ApiProxy().postNewChallenge(token, challengeName: nameTextField.text!, success: { (challenge) -> () in
                self.performSegueWithIdentifier("unwindToChallengeViewController", sender: self)
                
            }, failed: { (errorCode) -> () in
                self.displayAlert(errorCode)
                    
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

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
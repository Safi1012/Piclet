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
    @IBOutlet weak var createButton: UIButton!
    var token: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
    }

    @IBAction func pressedCreateTabBar(sender: UIBarButtonItem) {
        
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

extension CreateChallengeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
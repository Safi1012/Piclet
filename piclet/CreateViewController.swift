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
        if let challengeName = nameTextField.text {
            
            ApiProxy().postNewChallenge(User.getLoggedInUser(managedObjectContext)?.token, challengeName: challengeName, success: { (challenge) -> () in
                self.performSegueWithIdentifier("unwindToChallengeViewController", sender: self)
                
                }) { (errorCode) -> () in
                    self.displayAlert(errorCode)
                    
            }
        }
    }
    
    // validate Text Field before sending to server
}



// MARK: - UITextFieldDelegate

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
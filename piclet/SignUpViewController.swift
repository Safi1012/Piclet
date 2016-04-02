//
//  SignUpViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var termsOfServiceButton: UIButton!
    

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        googleButton.addBoarderTop()
        facebookButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    
    // MARK: UI
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
    }
    
    @IBAction func pressedFacebookButton(sender: UIButton) {
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
    }
    
    @IBAction func pressedTermsOfServiceButton(sender: UIButton) {
    }
}

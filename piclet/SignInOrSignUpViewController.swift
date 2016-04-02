//
//  SignInOrSignUpViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class SignInOrSignUpViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.addBoarderTop()
        googleButton.addBoarderTop()
        usernameButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }


    // MARK: - UI
    
    @IBAction func pressedFacebookButton(sender: UIButton) {
//        if let welcomeViewController = parentViewController as? WelcomeViewController {
//            welcomeViewController.loadSigInViewController()
//        }
    }
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
        if let welcomeViewController = parentViewController as? WelcomeViewController {
            welcomeViewController.loadGoogleViewController()
        }
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
    }
}

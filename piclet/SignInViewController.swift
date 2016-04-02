//
//  SignInViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        googleButton.addBoarderTop()
//        googleButton.addBorderBottom()
//        
//        facebookButton.addBoarderTop()
//        facebookButton.addBorderBottom()
//        
//        usernameButton.addBoarderTop()
//        usernameButton.addBorderBottom()
    }
    
    
    // MARK: UI
    
    @IBAction func pressedBackButton(sender: UIButton) {
        if let welcomeViewController = parentViewController as? WelcomeViewController {
            welcomeViewController.removeChildViewController()
        }
    }
    
}

//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var setupServerButton: UIButton!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
    }
    
    override func viewWillAppear(animated: Bool) {
        shoudlHideSignInButton()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    func uiStyling() {
        signInButton.addBoarderTop()
        setupServerButton.addBoarderTop()
        setupServerButton.addBoarderBottom()
    }
    
    func shoudlHideSignInButton() {
        if ServerAccess.sharedInstance.getServer() != nil {
            signInButton.hidden = false
        } else {
            signInButton.hidden = true
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func unwindToWelcomeViewController(segue: UIStoryboardSegue) {}
}
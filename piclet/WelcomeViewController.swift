//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var containerView: UIView!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSignInOrSignUpViewController()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func removeChildViewController() {
        self.childViewControllers[0].removeFromParentViewController()
        loadSignInOrSignUpViewController()
    }
    
    
    // MARK: - Load Views
    
    func loadSignInOrSignUpViewController() {
        let signInOrSignUpViewController = SignInOrSignUpViewController(nibName: "SignInOrSignUpViewController", bundle: NSBundle.mainBundle())
        addChildViewController(signInOrSignUpViewController, toContainerView: containerView)
    }
    
    func loadGoogleViewController() {
        let googleViewController = GoogleViewController(nibName: "GoogleViewController", bundle: NSBundle.mainBundle())
        addChildViewController(googleViewController, toContainerView: containerView)
    }
    
    
    
    
    

    
    func loadSigInViewController() {
        let signInViewController = SignInViewController(nibName: "SignInViewController", bundle: NSBundle.mainBundle())
        addChildViewController(signInViewController, toContainerView: containerView)
    }

    func loadSigUpViewController() {
        let signUpViewController = SignUpViewController(nibName: "SignUpViewController", bundle: NSBundle.mainBundle())
        addChildViewController(signUpViewController, toContainerView: containerView)
    }
    
    
}



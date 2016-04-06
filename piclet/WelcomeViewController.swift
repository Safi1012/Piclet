//
//  WelcomeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var usernameButton: UIButton!
    
    var selectedService = SignInService.username
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        facebookButton.addBoarderTop()
        googleButton.addBoarderTop()
        usernameButton.addBoarderTop()
        usernameButton.addBoarderBottom()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedFacebookButton(sender: UIButton) {
        selectedService = SignInService.facebook
        loadTermsOfServiceViewController()
    }
    
    @IBAction func pressedGoogleButton(sender: UIButton) {
        selectedService = SignInService.google
        loadTermsOfServiceViewController()
    }
    
    @IBAction func pressedUsernameButton(sender: UIButton) {
        selectedService = SignInService.username
        
        // perfrom segue to userVC
    }
    
    
    // MARK: - Navigation
    
    func loadTermsOfServiceViewController() {
        let tosViewController = TosViewController(nibName: "TosViewController", bundle: NSBundle.mainBundle())
        addChildViewController(tosViewController, toContainerView: view)
    }
    
    func navigateToSelectedServiceViewController() {
        // removeLastChildViewController(self)
        
        switch selectedService {
            
        case .facebook:
            performSegueWithIdentifier("toThirdPartyServiceViewController", sender: self)
            print("fb")
            
        case .google:
            performSegueWithIdentifier("toThirdPartyServiceViewController", sender: self)
            print("google")
            
        case .username:
            performSegueWithIdentifier("toUserViewController", sender: self)
        }
    }
}


enum SignInService {
    case facebook
    case google
    case username
}







//    func removeChildViewController() {
//        self.childViewControllers[0].removeFromParentViewController()
//        loadSignInOrSignUpViewController()
//    }
//
//    func loadSignInOrSignUpViewController() {
//        let signInOrSignUpViewController = SignInOrSignUpViewController(nibName: "SignInOrSignUpViewController", bundle: NSBundle.mainBundle())
//        addChildViewController(signInOrSignUpViewController, toContainerView: containerView)
//    }

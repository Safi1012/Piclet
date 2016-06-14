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
        
        // todo: check if app was opened for the first time
        // showOnboarding()
        
        uiStyling()
        
        // Google SignIn Service setup
        // GIDSignIn.sharedInstance().uiDelegate = self
        // GIDSignIn.sharedInstance().delegate = self
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
    
    
    // MARK: - Actions
    
    @IBAction func pressedSignInButton(sender: UIButton) {
        performSegueWithIdentifier("toUserViewController", sender: self)
    }
    
    @IBAction func pressedSetupServer(sender: AnyObject) {
        // performSegueWithIdentifier("toSetupServerViewController", sender: self)
    }
    
    @IBAction func unwindToWelcomeViewController(segue: UIStoryboardSegue) {}
}
/*
    
    
    // MARK: - Onboarding
    
    func showOnboarding() {
        // let page0 = EAIntroPage()
        // page0.title = "Welcome to Piclet"
        // page0.titlePositionY = 30.0
        // page0.desc = "Start sharing your Pictures and particacipate \n in competive challeneges."
        // page0.descPositionY = 100.0
        // page0.titleIconPositionY = 100.0
        // page0.titleIconView = UIImageView(image: UIImage(named: "picletIcon"))
        
        // build pages
        let page0 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_0", bundle: NSBundle.mainBundle())
        let page1 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_1", bundle: NSBundle.mainBundle())
        let page2 = EAIntroPage(customViewFromNibNamed: "Onboarding_Screen_2", bundle: NSBundle.mainBundle())
        
        // create introduction view
        let intro = EAIntroView(frame: self.view.bounds, andPages: [page0, page1, page2])
        intro.bgImage = UIImage(named: "backgroundLogin")
        // intro.delegate = self
        
        // display introduction view
        intro.showInView(self.view, animateDuration: 0.0)
    }
    
 */

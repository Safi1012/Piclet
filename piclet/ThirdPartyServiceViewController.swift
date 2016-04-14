//
//  ThirdPartyServiceViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ThirdPartyServiceViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var thirdPartyService: SignInService!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViewControllerToContainer()
    }
    
    
    // MARK: - UI
    
    func addViewControllerToContainer() {
        
        switch thirdPartyService! {
            
        case SignInService.facebook:
            print("To Do")
            
        case SignInService.google:
            let googleViewController = GoogleViewController(nibName: "GoogleViewController", bundle: NSBundle.mainBundle())
            addChildViewController(googleViewController, toContainerView: view)
            
        default:
            break;
        }
    }
    
    
    // MARK: - Navgiation
    
    func navigateToChallengeViewController() {
        performSegueWithIdentifier("toChallengesViewController", sender: self)
    }
}


// add google extension



// add fb extension
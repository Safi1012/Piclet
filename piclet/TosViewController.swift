//
//  TosViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class TosViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tosPressed(sender: UIButton) {
        if let welcomeViewController = parentViewController as? WelcomeViewController {
            welcomeViewController.navigateToSelectedServiceViewController()
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}


//        if let welcomeViewController = parentViewController as? WelcomeViewController {
//            welcomeViewController.loadSigInViewController()
//        }
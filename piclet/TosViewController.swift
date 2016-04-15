//
//  TosViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

class TosViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.sizeToFit()
        textView.layoutIfNeeded()
        textView.text = loadTermsOfService()
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.textContainer.lineFragmentPadding = 3.0;
    }
    
    func loadTermsOfService() -> String? {
        let filePath = NSBundle.mainBundle().pathForResource("termsOfService", ofType: "txt")!
        return try? String(NSString(contentsOfFile: filePath, encoding: NSUTF8StringEncoding))
    }
    
    @IBAction func tosPressed(sender: UIButton) {
        parentViewController?.performSegueWithIdentifier("toThirdPartyServiceViewController", sender: self)
    }
    
    @IBAction func cancelPressed(sender: UIButton) {
        if let welcomeViewController = parentViewController as? WelcomeViewController {
            removeLastChildViewController(welcomeViewController)
        }
    }
}
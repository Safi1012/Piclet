//
//  ChallengeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 27/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var challengeContainerView: UIView!
    
    var challengeTableViewController: ChallengeTableViewController!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = UIStoryboard(name: "ChallengeProfile", bundle: nil)
        challengeTableViewController = storyboard.instantiateViewControllerWithIdentifier("ChallengeTableViewController") as! ChallengeTableViewController
        
        addChildViewController(challengeTableViewController, toContainerView: challengeContainerView)
        
        styleNavigationBar()
    }
    
    
    // MARK: - UI
    
    func styleNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentPixel"), forBarMetrics: UIBarMetrics.Default)
    }
    
    @IBAction func pressedSegmentedControl(sender: UISegmentedControl) {
        challengeTableViewController.pressedSegmentedControl(sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toPostsViewController" {
            let destinationVC = segue.destinationViewController as! PostsViewController
            destinationVC.challenge = (sender as? Challenge)
        }
        if segue.identifier == "toCreateChallengeViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! CreateChallengeViewController
            destinationVC.token = User.getLoggedInUser(AppDelegate().managedObjectContext)!.token!
        }
    }
}


// MARK: - SegmentedControlState Enum

enum SegmentedControlState: Int {
    case hot = 0
    case new = 1
}
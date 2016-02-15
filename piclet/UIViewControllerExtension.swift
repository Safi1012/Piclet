
//
//  ViewControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 26/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation

var refreshControl = UIRefreshControl()

extension UIViewController {
    
    func addPullToRefresh(view: UIView, selector: String) {
        
        // blueSpinner
        let activityIndicatorView = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
        activityIndicatorView.startAnimating()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = true
        activityIndicatorView.autoresizingMask = [.FlexibleLeftMargin, .FlexibleRightMargin, .FlexibleTopMargin, .FlexibleBottomMargin]
        
        
        // refresh View
        let picletBlue = UIColor(red: 37.0/255.0, green: 106.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [NSForegroundColorAttributeName: picletBlue])
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.tintColor = UIColor.clearColor()
        refreshControl.addTarget(self, action: Selector(selector), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(refreshControl)

        
        // add blueSpinner to refresh View
        refreshControl.addSubview(activityIndicatorView)
        activityIndicatorView.center = CGPoint(x: refreshControl.bounds.midX, y: refreshControl.bounds.midY - 5.0)
    }
    
    func makePullToRefreshEndRefreshing() {
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - ChildViewController
    
    func addChildViewController(viewController: UIViewController, toContainerView view: UIView) {
        addChildViewController(viewController)
        
        viewController.view.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        view.addSubview(viewController.view)
        
        viewController.view.pinToSuperView()
        viewController.didMoveToParentViewController(self)
    }
    
    
    // MARK: - Alert
    
    func displayAlert(errorCode: String) {
        var alertController: UIAlertController
        
        switch (errorCode) {
            
        case "UnauthorizedError":
            alertController = UIAlertController.createAlertWithLoginSegue(errorCode, viewController: self)
            
        case "NotLoggedIn":
            alertController = UIAlertController.createAlertWithLoginSegue(errorCode, viewController: self)
            
        default:
            alertController = UIAlertController.createErrorAlert(errorCode)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}

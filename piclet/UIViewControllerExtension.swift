
//
//  ViewControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 26/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation
import BRYXBanner

var refreshControl = UIRefreshControl()

extension UIViewController {
    
    func addDefaultPullToRefresh(view: UIView, selector: String) {
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: Selector(selector), forControlEvents: .ValueChanged)
        
        view.insertSubview(refreshControl, atIndex: 0)
    }
    
    func makePullToRefreshEndRefreshing() {
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - ReloadData
    
    func shouldRefreshData(inout timestamp: NSDate?) -> Bool {
        
        if timestamp != nil {
            if TimeHandler().secondsPassedSinceDate(timestamp!) > 300 {
                timestamp = NSDate()
                return true
            }
            return false
        }
        timestamp = NSDate()
        return true
    }
    
    
    // MARK: - Banner
    
    func showBanner(title: String, subtitle: String, image: UIImage?, backgroundColor: UIColor, view: UIView) {
        let banner = Banner(title: title, subtitle: subtitle, image: image, backgroundColor: backgroundColor)
        banner.dismissesOnTap = true
        banner.springiness = .None
        banner.show(view, duration: 4.0)
    }
    
    
    // MARK: - Loading Spinner
    
    func showLoadingSpinner(offset: UIOffset, color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
        SVProgressHUD.setBackgroundColor(UIColor(white: 1, alpha: 0.0))
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.None)
        SVProgressHUD.setOffsetFromCenter(offset)
        SVProgressHUD.show()
    }
    
//    func showLoadingSpinner(offset: UIOffset) {
//        SVProgressHUD.setForegroundColor(UIColor.blackColor())
//        SVProgressHUD.setBackgroundColor(UIColor(white: 1, alpha: 0.0))
//        
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.None)
//        SVProgressHUD.setOffsetFromCenter(offset)
//        SVProgressHUD.show()
//    }

    func dismissLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
    }
    
    
    // MARK: - ChildViewController
    
    func addChildViewController(viewController: UIViewController, toContainerView view: UIView) {
        addChildViewController(viewController)
        
        viewController.view.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        view.addSubview(viewController.view)
        
        viewController.view.pinToSuperView()
        viewController.didMoveToParentViewController(self)
    }
    
    
    // MARK: - ChildViewController
    
    func addChildViewController(viewController: UIViewController, toView view: UIView) {
        self.addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.pinToSuperView()
        viewController.didMoveToParentViewController(self)
    }
    
    func removeLastChildViewController(viewController: UIViewController) {
        let vc = viewController.childViewControllers.last
        vc?.willMoveToParentViewController(nil)
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
    }
    
    
    // MARK: - Alert
    
    func displayAlert(errorCode: String) {
        var alertController: UIAlertController
        
        switch (errorCode) {
            
        case "UnauthorizedError":
            alertController = UIAlertController.createAlertWithLoginSegue(errorCode, viewController: self)
            
        case "NotLoggedIn":
            alertController = UIAlertController.createAlertWithLoginSegue(errorCode, viewController: self)
            
        case "NetworkError":
            self.showBanner("No Internet Coneection", subtitle: "", image: UIImage(named: "bannerPlug"), backgroundColor: UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1), view: self.view)
            return
            
        default:
            alertController = UIAlertController.createErrorAlert(errorCode)
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}


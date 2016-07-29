
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

// MARK: - Extends the UIViewController class
extension UIViewController {
    
    /**
     Adds a pull to refresh animation to a given view
     
     - parameter view:     the pull to refresh animation will be added to this UIView
     - parameter selector: the selector which will be called when initiating the pull to refresh animation
     */
    func addDefaultPullToRefresh(view: UIView, selector: String) {
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: Selector(selector), forControlEvents: .ValueChanged)
        
        view.insertSubview(refreshControl, atIndex: 0)
    }
    
    /**
     Stops the pull to refresh animation
     */
    func makePullToRefreshEndRefreshing() {
        refreshControl.endRefreshing()
    }
    
    
    // MARK: - ReloadData
    
    /**
     Determines if new data should be refreshed
     
     - parameter timestamp: a unix timestamp
     
     - returns: true if the current data should be refreshed, false if not
     */
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
    
    /**
     Displays a banner on top of a UIView
     
     - parameter title:           the banner title
     - parameter subtitle:        the banner subtitle
     - parameter image:           the banner image
     - parameter backgroundColor: the banner background color
     - parameter view:            the view which will show the banner
     */
    func showBanner(title: String, subtitle: String, image: UIImage?, backgroundColor: UIColor, view: UIView) {
        let banner = Banner(title: title, subtitle: subtitle, image: image, backgroundColor: backgroundColor)
        banner.dismissesOnTap = true
        banner.springiness = .None
        banner.show(view, duration: 4.0)
    }
    
    
    // MARK: - Loading Spinner
    
    /**
     Display a loading spinner
     
     - parameter offset: the offset which should be applies
     - parameter color:  the loading spinner color
     */
    func showLoadingSpinner(offset: UIOffset, color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
        SVProgressHUD.setBackgroundColor(UIColor(white: 1, alpha: 0.0))
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.Custom)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.None)
        SVProgressHUD.setOffsetFromCenter(offset)
        SVProgressHUD.show()
    }

    /**
     Dismisses the loading spinner
     */
    func dismissLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue()) {
            SVProgressHUD.dismiss()
        }
    }
    
    
    // MARK: - Text
    
    /**
     Adds a centered label to an UIView
     
     - parameter text: the text of the label
     - parameter view: the UIView which will the label will be added
     */
    func addCenteredLabel(text: String, view: UIView) {
        let label = UILabel()
        label.frame.size.height = 42
        label.frame.size.width = view.frame.size.width
        label.center = view.center
        label.center.y = (view.frame.size.height/2)
        label.numberOfLines = 2
        label.textColor = UIColor.grayColor()
        label.text = text
        label.textAlignment = .Center
        label.tag = 1
        
        if #available(iOS 8.2, *) {
            label.font = UIFont.systemFontOfSize(15.0, weight: UIFontWeightLight)
        } else {
            label.font = UIFont(name: "HelveticaNeue-Light", size: 15)
        }
        
        view.addSubview(label)
    }
    
    /**
     Removes the centered label (see 'addCenteredLabel()')
     
     - parameter view: the UIView which contains the added label
     */
    func removeCentered(view: UIView) {
        view.viewWithTag(1)?.removeFromSuperview()
    }
    
    
    // MARK: - ChildViewController
    
    /**
     Adds a viewController (child) to a another viewController (parent)
     
     - parameter viewController: the child viewController
     - parameter view:           the viewControllers (parent) container view which will hold the view of the added child viewController
     */
    func addChildViewController(viewController: UIViewController, toContainerView view: UIView) {
        addChildViewController(viewController)
        
        viewController.view.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        view.addSubview(viewController.view)
        
        viewController.view.pinToSuperView()
        viewController.didMoveToParentViewController(self)
    }
    
    
    // MARK: - Alert
    
    /**
     Creates and displays an error Alert
     
     - parameter errorCode: the errorCode which will be used to find the appropriate errorMessage. See 'ErrorHandler' for more information
     */
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


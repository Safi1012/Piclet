
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
    
    func makePullToRefreshToTableView(tableName: UITableView,triggerToMethodName: String) {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: Selector(triggerToMethodName), forControlEvents: UIControlEvents.ValueChanged)
        tableName.addSubview(refreshControl)
    }
    
    func makePullToRefreshEndRefreshing() {
        refreshControl.endRefreshing()
    }
    
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
    
    func showLoadingSpinner(viewController: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), {
            if viewController.isKindOfClass(UITableViewController) {
                let tableView = (viewController as! UITableViewController).view
                // let loadingSpinner = MBProgressHUD.showHUDAddedTo(tableView.superview, animated: true)
                // loadingSpinner.labelText = "Loading Data"
            } else {
                // let loadingSpinner = MBProgressHUD.showHUDAddedTo(viewController.view, animated: true)
                // loadingSpinner.labelText = "Loading Data"
            }
        })
    }
    
    func hideLoadingSpinner(viewController: UIViewController) {
        dispatch_async(dispatch_get_main_queue(), {
            if viewController.isKindOfClass(UITableViewController) {
                let tableView = (viewController as! UITableViewController).view
                // MBProgressHUD.hideHUDForView(tableView.superview, animated: true)
            } else {
                // MBProgressHUD.hideHUDForView(viewController.view, animated: true)
            }
        })
    }
}


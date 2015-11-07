
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
    
    func showLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            let loadingSpinner = MBProgressHUD.showHUDAddedTo(self.tableView.superview, animated: true)
            loadingSpinner.labelText = "Loading Data"
        })
    }
    
    func hideLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.tableView.superview, animated: true)
        })
    }
}


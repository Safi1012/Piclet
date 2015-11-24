
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
    
    
    // MARK: - Imagepicker
    
    func displayCamera(imagePickerController: UIImagePickerController) {
        imagePickerController.sourceType = .Camera
        imagePickerController.mediaTypes = ["kUTTypeImage"]
        imagePickerController.allowsEditing = false
        imagePickerController.showsCameraControls = true
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func displayImageGallery(imagePickerController: UIImagePickerController) {
        imagePickerController.sourceType = .PhotoLibrary
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    

}


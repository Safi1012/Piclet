//
//  AlertControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 20/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Extends the UIAlertController class
extension UIAlertController {
    
    /**
     Creates an UIAlertController with a error message
     
     - parameter errorCode: this errorCode is used to identify which error message should be displayed. For more information see: 'ErrorHandler'
     
     - returns: UIAlertController
     */
    public class func createErrorAlert(errorCode: String) -> UIAlertController {
        let error = ErrorHandler().getTitleAndMessageError(errorCode)
        
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        return alertController
    }
    
    /**
     Creates an UIAlertController with an error message and a segue which leads to the welcomeView when pressing the 'Signup' Button of the Alert
     
     - parameter errorCode:      this errorCode is used to identify which error message should be displayed. For more information see: 'ErrorHandler'
     - parameter viewController: the viewController which should present the welcomeView
     
     - returns: UIAlertController
     */
    public class func createAlertWithLoginSegue(errorCode: String, viewController: UIViewController) -> UIAlertController {
        let error = ErrorHandler().getTitleAndMessageError(errorCode)
        
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Signup", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
            dispatch_async(dispatch_get_main_queue()) {
                if (UIApplication.sharedApplication().delegate as! AppDelegate).welcomeViewController != nil {
                    viewController.performSegueWithIdentifier("unwindToWelcomeViewController", sender: self)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewControllerWithIdentifier("WelcomeViewController")
                    viewController.presentViewController(loginVC, animated: true, completion: nil)
                }
                UserAccess.sharedInstance.deleteAllUsers()
            }
        }))
        return alertController
    }
}






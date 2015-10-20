//
//  AlertControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 20/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    public class func createErrorAlert(errorCode: String) -> UIAlertController {
        let error = ErrorHandler().getTitleAndMessageError(errorCode)
        
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        return alertController
    }
    
    public class func createAlertWithLoginSegue(errorCode: String, viewController: UIViewController) -> UIAlertController {
        let error = ErrorHandler().getTitleAndMessageError(errorCode)
        
        let alertController = UIAlertController(title: error.title, message: error.message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "Signup", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
        
            dispatch_async(dispatch_get_main_queue()) {
                if (UIApplication.sharedApplication().delegate as! AppDelegate).loginViewController != nil {
                    viewController.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                    viewController.presentViewController(loginVC, animated: true, completion: nil)
                }
            }
        }))
        return alertController
    }
}






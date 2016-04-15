//
//  AppDelegate.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import RealmSwift

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var loginViewController: LoginViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // forcing navigationBar to change UIBar -> preferredStatusBarStyle will get called on childs
        UINavigationBar.appearance().barStyle = UIBarStyle.Black
        
        if (UserAccess.sharedInstance.isUserLoggedIn()) {
            self.window?.rootViewController = self.window?.rootViewController?.storyboard?.instantiateViewControllerWithIdentifier("ChallengeProfile")
        }
        
        // tabBar styling
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        UITabBar.appearance().barTintColor = UIColor(red: 37.0/255.0, green: 106.0/255.0, blue: 185.0/255.0, alpha: 1.0)
        UITabBar.appearance().translucent = false
        let greyColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : greyColor], forState: UIControlState.Normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.whiteColor()], forState: UIControlState.Selected)
        
        // navBar backButton styling
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "navBarBack")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "navBarBack")
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        
        // google sign-In
        GIDSignIn.sharedInstance().clientID = "341730212595-ir18hmkfcji9ke2h7opc4t7ovdlbfj68.apps.googleusercontent.com"
    
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        // self.saveContext()
    }
    
    @available(iOS, introduced=8.0, deprecated=9.0)
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication!, annotation: annotation)
    }
    
    func appDelegate () -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    // MARK: - Rotation

    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        
        if self.window?.rootViewController?.presentedViewController is JTSImageViewController {
            let imageViewController = self.window!.rootViewController!.presentedViewController as! JTSImageViewController
            
            if imageViewController.isPresented {
                return UIInterfaceOrientationMask.All;
            }
            return UIInterfaceOrientationMask.Portrait;
        }
        return UIInterfaceOrientationMask.Portrait;
    }
}



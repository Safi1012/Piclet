//
//  AppDelegate.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import RealmSwift
import Fabric
import Crashlytics

let realm = try! Realm()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var welcomeViewController: WelcomeViewController?

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
        
        // fabric
        Fabric.with([Crashlytics.self])
        
        
        
        
        
        // register the supported interaction types
        let notifcationSettings = UIUserNotificationSettings(forTypes: [.Badge, .Sound, .Alert], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notifcationSettings)
        
        // register for remote notifications
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        // handling the notification
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? UILocalNotification {
            print("\(remoteNotification.userInfo)")
            application.applicationIconBadgeNumber = remoteNotification.applicationIconBadgeNumber - 1;
            
//            NSString *itemName = [localNotif.userInfo objectForKey:ToDoItemKey];
//            [viewController displayItem:itemName];  // custom method
//            app.applicationIconBadgeNumber = localNotif.applicationIconBadgeNumber-1;
        }
        
        
        // not sure why?
//        [window addSubview:viewController.view];
//        [window makeKeyAndVisible];
    
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
    
    
    // MARK: - Notifications
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString: String = (deviceToken.description as NSString)
            .stringByTrimmingCharactersInSet(characterSet)
            .stringByReplacingOccurrencesOfString( " ", withString: "") as String
        
        print("\n \(deviceTokenString)")
        print(deviceToken.description)
        
        ApiProxy().deviceToken = deviceTokenString
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Remote Notification Error: \(error.description)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        // Tells the app that a remote notification arrived that indicates there is data to be fetched.
        
        let state = application.applicationState
        
        if state == .Inactive {
            // show the view with the content of the push
            completionHandler(UIBackgroundFetchResult.NewData)
            
        } else if state == .Background {
            // refresh local model
            completionHandler(UIBackgroundFetchResult.NewData)
            
        } else if state == .Active {
            // show alert
            completionHandler(UIBackgroundFetchResult.NewData)
            
        }
        
        // the completetion handlet must be called -> see other examples
        completionHandler(UIBackgroundFetchResult.NoData)
    }

    
    
    @available(iOS, introduced=8.0, deprecated=9.0)
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication!, annotation: annotation)
    }
    
    func appDelegate () -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    
    
    
    // MARK: - Fabric
    
    func logUser(username: String) {
        Crashlytics.sharedInstance().setUserIdentifier(username)
        Crashlytics.sharedInstance().setUserName(username)
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


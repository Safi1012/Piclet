//
//  TabBarViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add viewControllers
        let challengeNavigationController = UIStoryboard.init(name: "Challenge", bundle: nil).instantiateInitialViewController()!
        let profileNavigationController = UIStoryboard.init(name: "Profile", bundle: nil).instantiateInitialViewController()!
        self.viewControllers = [challengeNavigationController, profileNavigationController]
        
        // add tabBar icons
        let challengeIcon = UIImage(named: "tabBarChallenges")
        let profileIcon = UIImage(named: "tabBarProfil")
        challengeNavigationController.tabBarItem = UITabBarItem(title: "Challenge", image: challengeIcon, tag: 1)
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: profileIcon, tag: 2)
        
        // style tabBar icons
        for item in self.tabBar.items! {
            let greyColor = UIColor(red: 180.0/255.0, green: 180.0/255.0, blue: 180.0/255.0, alpha: 1.0)
            item.image = item.selectedImage?.imageWithColor(greyColor).imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

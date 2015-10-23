//
//  ChallengeViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 23/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var navigationView: ChallengesView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        let topBorder = CALayer()
//        topBorder.frame = CGRectMake(0.0, navigationView.bounds.height, navigationView.bounds.width, 3.0);
//        topBorder.backgroundColor = UIColor(red: 37.0/255.0, green: 106.0/255.0, blue: 185.0/255.0, alpha: 1.0).CGColor
//        
//        self.navigationItem
//        
//        self.navigationController?.navigationBar.subviews
//        
//        
//        self.layer.addSublayer(topBorder)
        
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "transparentPixel"), forBarMetrics: UIBarMetrics.Default)
        
        
        
        
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
//        // "Pixel" is a solid white 1x1 image.
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
//        
//        
//        
//        
//        
//        
//        
//        
//        var vieww = self.navigationController?.navigationBar.subviews[0].hidden = true
        
        // self.navigationController?.navigationBar.layoutMargins
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

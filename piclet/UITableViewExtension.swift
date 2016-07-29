//
//  UITableViewExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/05/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

// MARK: - Extends the UITableView class
extension UITableView {
    
    /**
     Adds an acitvity indicator view as a footer view
     */
    func addActivityIndicatorFooterView() {
        let activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
            activityIndicator.frame =  CGRectMake(0.0, 0.0, 35.0, 35.0)
        
        let activityIndicatorView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.mainScreen().bounds.width, height: 70.0))
            activityIndicatorView.addSubview(activityIndicator)
        
        let border = CALayer()
            border.backgroundColor = UIColor(red: 200.0/255.0, green: 199.0/255.0, blue: 204.0/255.0, alpha: 1.0).CGColor
            border.frame = CGRect(x: 15, y: 0, width: activityIndicatorView.frame.width - separatorInset.left, height: 0.5)
        
        activityIndicatorView.layer.addSublayer(border)
        activityIndicator.center = activityIndicatorView.center;
        tableFooterView = activityIndicatorView
    }
}

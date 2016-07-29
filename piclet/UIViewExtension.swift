//
//  UIViewExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

// MARK: - Extends the UIView class
extension UIView {
    
    /**
     Pins a view to its superView
     */
    func pinToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = true
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[subview]|", options: .AlignAllBaseline, metrics: nil, views: ["subview": self])
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[subview]|", options: .AlignAllBaseline, metrics: nil, views: ["subview": self])
        self.superview?.addConstraints(horizontalConstraints)
        self.superview?.addConstraints(verticalConstraints)
    }
    
    /**
     Adds an activity indicator as subview. This indicator should be used when new challenges or posts are beeing loaded
     */
    func addActivityIndicatorSubview() {
        let activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
        activityIndicator.bounds =  CGRectMake(0.0, 0.0, 35.0, 35.0)
        activityIndicator.center.x = self.center.x
        activityIndicator.center.y = CGRectGetMidY(self.bounds)
        
        self.addSubview(activityIndicator)
    }
    
    /**
     Starts animating the indicator view
     */
    func startAnimatingIndicatorView() {
        (self.subviews[0] as? ActivityIndicatorView)?.startAnimating()
    }
    
    /**
     Stops and hides the animating indicator view
     */
    func stopAnimatingIndicatorView() {
        (self.subviews[0] as? ActivityIndicatorView)?.stopAnimating()
    }
}
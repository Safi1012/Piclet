//
//  UIViewExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

extension UIView {
    
    func pinToSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = true
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[subview]|", options: .AlignAllBaseline, metrics: nil, views: ["subview": self])
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[subview]|", options: .AlignAllBaseline, metrics: nil, views: ["subview": self])
        self.superview?.addConstraints(horizontalConstraints)
        self.superview?.addConstraints(verticalConstraints)
    }
}
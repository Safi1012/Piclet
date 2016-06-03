//
//  UIButtonExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 28/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

extension UIButton {
    
    func addRoundButtonBorder() {
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
    
    func addBoarderTop() {
        let topLineView = UIView(frame: CGRectMake(0, 0, self.frame.size.width, 0.5))
        topLineView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.85)
        self.addSubview(topLineView)
    }
    
    func addBoarderBottom() {
        let topLineView = UIView(frame: CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5))
        topLineView.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.85)
        self.addSubview(topLineView)
    }
}

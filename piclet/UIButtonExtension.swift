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
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}

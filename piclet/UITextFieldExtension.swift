//
//  UITextFieldExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 28/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

// MARK: - Extends the UITextField class
extension UITextField {
    
    /**
      Adds a border to the bottom of a UITextField
     
     - parameter color: the border's color
     */
    func addBottomBorder(color: UIColor) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
        bottomBorder.backgroundColor = color.CGColor
        self.layer.addSublayer(bottomBorder)
    }
    
    /**
     Change the placeholders color
     
     - parameter color: the new color of the placeholder
     */
    func changePlaceholderColoring(color: UIColor) {
        if (self.placeholder != nil) {
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:color])
        }
    }
}

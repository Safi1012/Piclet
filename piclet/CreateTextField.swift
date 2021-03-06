//
//  CreateTextField.swift
//  piclet
//
//  Created by Filipe Santos Correa on 19/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class CreateTextField: UITextField {

    override func drawRect(rect: CGRect) {
        addBottomBorder()
        
        colorizePlaceholder()
        colorizeTextinput()
    }
    
    func addBottomBorder() {
        let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
            bottomBorder.backgroundColor = UIColor.darkTextColor().CGColor
        
        self.layer.addSublayer(bottomBorder)
    }
    
    func colorizePlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.lightGrayColor()])
    }
    
    func colorizeTextinput() {
        self.textColor = UIColor.darkTextColor()
    }
}
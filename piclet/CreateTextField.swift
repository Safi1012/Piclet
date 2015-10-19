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
        addTopBorder()
        addBottomBorder()
        
        colorizePlaceholder()
        colorizeTextinput()
    }
    
    func addTopBorder() {
        let topBorder = CALayer()
            topBorder.frame = CGRectMake(0.0, 0.0, self.frame.size.width, 1.0);
            topBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        
        self.layer.addSublayer(topBorder)
    }
    
    func addBottomBorder() {
        let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, self.frame.size.height - 1, self.frame.size.width, 1.0);
            bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        
        self.layer.addSublayer(bottomBorder)
    }
    
    func colorizePlaceholder() {
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkTextColor()])
    }
    
    func colorizeTextinput() {
        self.textColor = UIColor.darkTextColor()
    }
    
    
    
    // MARK: - TextField
    
    override func textRectForBounds(bounds: CGRect) -> CGRect {
        super.textRectForBounds(bounds)
        return CGRectInset(bounds, 20, 10);
    }
    
    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        super.editingRectForBounds(bounds)
        return CGRectInset(bounds, 20, 10);
    }

}
//
//  CreateViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 19/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyling()
    }

    
    // MARK: - UI
    
    func uiStyling() {
        addBorderStyling(nameTextField)
        addBorderStyling(descriptionTextField)
        stylePlaceholder(nameTextField)
        stylePlaceholder(descriptionTextField)
    }
    
    func addBorderStyling(textField: UITextField) {
        let topBorder = CALayer()
            topBorder.frame = CGRectMake(0.0, 0.0, textField.frame.size.width, 1.0);
            topBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        
        let bottomBorder = CALayer()
            bottomBorder.frame = CGRectMake(0.0, textField.frame.size.height - 1, textField.frame.size.width, 1.0);
            bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        
        textField.layer.addSublayer(topBorder)
        textField.layer.addSublayer(bottomBorder)
    }
    
    func stylePlaceholder(textField: UITextField) {
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkTextColor()])
        textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSForegroundColorAttributeName:UIColor.darkTextColor()])
    }
    
}

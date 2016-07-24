//
//  UIImageExtenstion.swift
//  piclet
//
//  Created by Filipe Santos Correa on 31/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

extension UIImage {
    
    /**
     Tint an image with a color
     
     - parameter color1: the color which should be applied to the selected image
     
     - returns: the new tinted image
     */
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        
        let context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
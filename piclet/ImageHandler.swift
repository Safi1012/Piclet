//
//  ImageHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 09/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ImageHandler {
    
    
    func covertImageForUpload(image: UIImage) -> NSData? {
        return compressImage(image)
    }
    
    private func compressImage(image: UIImage) -> NSData? {
        let newWidth = ImageServerWidth.large.rawValue
        let newHeight = CGFloat((image.size.height / image.size.width)) * newWidth // keeps the same aspect ratio
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0.0, 0.0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7);
        UIGraphicsEndImageContext()
    
        return imageData
    }
}


enum ImageServerWidth: CGFloat {
    case small = 360.0
    case medium = 720.0
    case large = 1440.0
}

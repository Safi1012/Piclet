//
//  ImageHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 09/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import UIKit

class ImageHandler {
    
    let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
    
    func convertAvatarImageForUpload(image: UIImage, imageSize: ImageAvatarServerWidth) -> NSData? {
        return cropImage(image, imageSize: imageSize.rawValue)
    }
    
    func convertPostsImageForUpload(image: UIImage, imageSize: ImagePostsServerWidth) -> NSData? {
        return compressImage(image, imageSize: imageSize.rawValue)
    }
    
    private func cropImage(image: UIImage, imageSize: CGFloat) -> NSData? {
        let newWidth: CGFloat!
        let newHeight: CGFloat!

        if image.size.width < image.size.height {
            newHeight = (imageSize / image.size.width) * image.size.height
            newWidth = imageSize
        } else if image.size.width > image.size.height{
            newWidth = (imageSize / image.size.height) * image.size.width
            newHeight = imageSize
        } else {
            newWidth = imageSize
            newHeight = imageSize
        }
        
        // resize to the smaller rect length
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0.0, 0.0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // crop
        let cropPositionX = (newWidth - imageSize) / 2.0
        let cropPositionY = (newHeight - imageSize) / 2.0
        let cropRect = CGRectMake(cropPositionX, cropPositionY, imageSize, imageSize)
        let imageRef = CGImageCreateWithImageInRect(resizedImage.CGImage, cropRect)!
        let croppedImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        let imageData = UIImageJPEGRepresentation(croppedImage, 0.7);
        
        return imageData
    }
    
    private func compressImage(image: UIImage, imageSize: CGFloat) -> NSData? {
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        newHeight = (image.size.height / image.size.width) * imageSize
        newWidth = imageSize
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0.0, 0.0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7);
        UIGraphicsEndImageContext()
    
        return imageData
    }
}

struct PostImage {
    var imagePath: String!
    var postID: String!
}

enum ImagePostsServerWidth: CGFloat {
    case small = 360.0
    case medium = 720.0
    case large = 1440.0
}

enum ImageAvatarServerWidth: CGFloat {
    case small = 20.0
    case medium = 100.0
    case large = 400.0
}




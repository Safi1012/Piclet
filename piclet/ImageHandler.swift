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
        return compressImage(image, imageSize: imageSize.rawValue)
    }
    
    func convertPostsImageForUpload(image: UIImage, imageSize: ImagePostsServerWidth) -> NSData? {
        return compressImage(image, imageSize: imageSize.rawValue)
    }
    
    
    
//    func covertImageForUpload(image: UIImage) -> NSData? {
//        return compressImage(image)
//    }
    
    private func compressImage(image: UIImage, imageSize: CGFloat) -> NSData? {
        let newWidth: CGFloat
        let newHeight: CGFloat
        
        if image.size.width > image.size.height {
            newHeight = (image.size.width / image.size.height) * imageSize
            newWidth = imageSize
            
        } else if image.size.width < image.size.height {
            newHeight = (image.size.height / image.size.width) * imageSize
            newWidth = imageSize
            
        } else {
            newHeight = imageSize
            newWidth = imageSize
            
        }
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0.0, 0.0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7);
        UIGraphicsEndImageContext()
    
        return imageData
    }
    
    func getMissingImagePosts(posts: [Post], imageSize: ImageSize, imageFormat: ImageFormat) -> [PostImage] {
        var postImages = [PostImage]()

        for post in posts {
            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_\(imageSize.rawValue)" + ".\(imageFormat.rawValue)")

            if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
                postImages.append(PostImage(imagePath: imagePath, postID: post.id))
            }
        }
        return postImages
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




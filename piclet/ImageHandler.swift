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
    
    func covertImageForUpload(image: UIImage) -> NSData? {
        return compressImage(image)
    }
    
    private func compressImage(image: UIImage) -> NSData? {
        let newWidth = ImageServerWidth.large.rawValue
        let newHeight = CGFloat((image.size.height / newWidth)) * newWidth // keeps the same aspect ratio
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.drawInRect(CGRectMake(0.0, 0.0, newWidth, newHeight))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = UIImageJPEGRepresentation(resizedImage, 0.7);
        UIGraphicsEndImageContext()
        
        
        print(resizedImage.size.width)
        print(resizedImage.size.height)
    
        return imageData
    }
    
    
    func loadImagePosts(posts: [Post], challengeID: String, imagesize: ImageSize, imageFormat: ImageFormat, complete: () -> () ) {

        let postImages = getMissingImagePosts(posts, imageSize: imagesize, imageFormat: imageFormat)
        var numberCallback = 0 // postImages.count

        for postImage in postImages {

            ApiProxy().getPostImageInSize(challengeID, postID: postImage.postID, imageSize: imagesize, imageFormat: imageFormat, success: { () -> () in
                ++numberCallback
                if numberCallback == postImages.count {
                    complete()
                }
                
            }, failed: { (errorCode) -> () in
                ++numberCallback
                if numberCallback == postImages.count {
                    complete()
                }

            })
        }
        complete()
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func getPostImage(challengeID: String, postID: String, imageSize: ImageSize, imageFormat: ImageFormat, success: (image: UIImage) -> (), failed: () -> () ) {
        let imagePath = documentPath.stringByAppendingPathComponent(postID + "_\(imageSize.rawValue)" + ".\(imageFormat.rawValue)")
        
//        if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
//            
//            ApiProxy().getPostImageInSize(challengeID, postID: postID, imageSize: imageSize, imageFormat: imageFormat, success: { () -> () in
//                success(image: UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath)))
//                
//            }, failed: { (errorCode) -> () in
//                failed()
//                
//            })
//        } else {
//            success(image: UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath)))
//        }
        
    }
    
    
    

    
//    func loadImage(postID: String, success: (image: UIImage) -> (), failed: () -> () ) {
//        
//        ApiProxy().getPostImageInSize(challenge.id, postID: postID, imageSize: ImageSize.medium, imageFormat: ImageFormat.jpeg, success: { () -> () in
//            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_medium" + ".webp")
//            success(image: UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(imagePath)))
//            
//        }, failed: { (errorCode) -> () in
//            failed()
//            
//        })
//    }
//    
//    func loadImagePosts(posts: [Post], challengeID: String, imagesize: ImageSize, imageFormat: ImageFormat) {
//        
//        let postImages = getMissingImagePosts(posts, imageSize: imagesize, imageFormat: imageFormat)
//        let numberCallback = postImages.count
//        
//        for postImage in postImages {
//            
//            ApiProxy().getPostImageInSize(challengeID, postID: postImage.postID, imageSize: imagesize, imageFormat: imageFormat, success: { () -> () in
//                
//            }, failed: { (errorCode) -> () in
//                
//            })
//        }
//    }
//    
//    func getMissingImagePosts(posts: [Post], imageSize: ImageSize, imageFormat: ImageFormat) -> [PostImage] {
//        var postImages = [PostImage]()
//        
//        for post in posts {
//            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_\(imageSize.rawValue)" + ".\(imageFormat.rawValue)")
//            
//            if !NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
//                postImages.append(PostImage(imagePath: imagePath, postID: post.id))
//            }
//        }
//        return postImages
//    }
    
    
    
    
    
    
    
    
    //    func getThumbnailsOfChallenge() {
    //
    //        for post in posts {
    //
    //            ApiProxy().getPostImageInSize(challenge.id, postID: post.id, imageSize: ImageSize.medium, imageFormat: ImageFormat.webp, success: { () -> () in
    //
    //            }, failed: { (errorCode) -> () in
    //                self.displayAlert(errorCode)
    //            })
    //        }
    //    }
    //
    //    func checkIfThumbnailsExists() -> Bool {
    //
    //        for post in posts {
    //            let imagePath = documentPath.stringByAppendingPathComponent(post.id + "_medium" + ".webp")
    //
    //            if NSFileManager.defaultManager().fileExistsAtPath(imagePath) {
    //                // return true
    //            }
    //        }
    //        return false
    //    }
}

struct PostImage {
    var imagePath: String!
    var postID: String!
}


enum ImageServerWidth: CGFloat {
    case small = 360.0
    case medium = 720.0
    case large = 1440.0
}

//
//  UIImagePickerControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/01/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit
import MobileCoreServices

// MARK: - Extends the UIImagePickerController class
extension UIImagePickerController {
    
    /**
     Display the camera view on the phone
     
     - parameter viewController: the viewControlelr which handles the camera view
     */
    func displayCamera(viewController: UIViewController) {
        self.sourceType = .Camera
        self.mediaTypes = [kUTTypeImage as String]
        self.allowsEditing = false
        self.showsCameraControls = true
        
        viewController.presentViewController(self, animated: true, completion: nil)
    }
    
    /**
     Displays the iPhone image gallery
     
     - parameter viewController: the viewControlelr which handles the iPhone image gallery
     */
    func displayImageGallery(viewController: UIViewController) {
        self.sourceType = .PhotoLibrary
        
        viewController.presentViewController(self, animated: true, completion: nil)
    }
    
    /**
     Checks if the device has a camera
     
     - returns: true if the the device has a camera, false if not
     */
    func isCameraAvailableForUse() -> Bool {
        if self.isCameraAvailable() && doesCameraSupportTakingPhotos() {
            return true
        }
        return false
    }
    
    /**
     Checks if the camera is ready for use
     
     - returns: true if the camera is ready for use, false if not
     */
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    /**
     Checks if the camera supports taking photos
     
     - returns: true if the camera supports taking photos, false if not
     */
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
    /**
     Checks if the camera supports a given media type
     
     - parameter mediaType:  the media type wich should be checked (e.g. Image, Video)
     - parameter sourceType: the source to use when picking an image or when determining available media types
     
     - returns: true if the camera supports the media type, false if not
     */
    private func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool {
        let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        
        if let types = availableMediaTypes {
            for type in types {
                if type == mediaType {
                    return true
                }
            }
        }
        return false
    }
}
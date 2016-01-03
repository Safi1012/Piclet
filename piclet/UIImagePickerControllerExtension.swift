//
//  UIImagePickerControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 03/01/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit
import MobileCoreServices

extension UIImagePickerController {
    
    func displayCamera(viewController: UIViewController) {
        self.sourceType = .Camera
        self.mediaTypes = [kUTTypeImage as String]
        self.allowsEditing = false
        self.showsCameraControls = true
        
        viewController.presentViewController(self, animated: true, completion: nil)
    }
    
    func displayImageGallery(viewController: UIViewController) {
        self.sourceType = .PhotoLibrary
        
        viewController.presentViewController(self, animated: true, completion: nil)
    }
    
    func isCameraAvailableForUse() -> Bool {
        if self.isCameraAvailable() && doesCameraSupportTakingPhotos() {
            return true
        }
        return false
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
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
//
//  ImagePickerViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 07/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    var token: String!
    var imagePickerController: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isCameraAvailable() && self.doesCameraSupportTakingPhotos() {
            imagePickerController = UIImagePickerController()
            imagePickerController!.delegate = self
            imagePickerController!.sourceType = .Camera
            imagePickerController!.mediaTypes = [kUTTypeImage as String]
            imagePickerController!.allowsEditing = false
            imagePickerController!.showsCameraControls = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    

    // MARK: - UI
    
    @IBAction func pressedCamera(sender: UIButton) {
        displayCamera()
    }
    
    @IBAction func pressedCameraRoll(sender: UIButton) {
        
    }
    
    
    // MARK: - UIImagePickerController
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
    func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool{
        let availableMediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)
        
        if let types = availableMediaTypes{
            for type in types{
                if type == mediaType{
                    return true
                }
            }
        }
        return false
    }

    func displayCamera() {
        if let imagePickerController = imagePickerController {
            presentViewController(imagePickerController, animated: true, completion: nil)
        }
    }
    
    func getImageFilePath() -> String {
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        return documentPath.stringByAppendingPathComponent("shotPicture.webp")
    }
    
}


extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.writeWebPToDocumentsWithFileName("shotPicture", quality: 0.7)
            let imageViewWebP = UIImageView(image: UIImage(webPData: NSFileManager.defaultManager().contentsAtPath(getImageFilePath())))
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
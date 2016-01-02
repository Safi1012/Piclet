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
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var closeImageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var token: String!
    var challengeID: String!
    var pickedImage: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        styleImagePreview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.isCameraAvailable() || !self.doesCameraSupportTakingPhotos() {
            cameraButton.hidden = true
        } else {
            cameraButton.hidden = false
        }
    }



    // MARK: - UI
    
    @IBAction func pressedCamera(sender: UIButton) {
        displayCamera()
    }
    
    @IBAction func pressedCameraRoll(sender: UIButton) {
        displayImageGallery()
    }
    
    @IBAction func pressedClosePreviewImage(sender: UIButton) {
        pickedImage = nil
        previewImageView.image = nil
        previewImageView.hidden = true
        closeImageButton.hidden = true
    }
    
    func styleImagePreview() {
        previewImageView.layer.cornerRadius = CGFloat(7.0)
        previewImageView.layer.borderWidth = CGFloat(1.0)
        previewImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        previewImageView.clipsToBounds = true
    }
    
    @IBAction func pressedNextNavBarItem(sender: UIBarButtonItem) {
        if let pickedImage = pickedImage {
            performSegueWithIdentifier("toImageUploadViewController", sender: pickedImage)
        } else {
            displayAlert("NoPictureError")
        }
    }
    
    
    // MARK: - UIImagePickerController
    
    func displayCamera() {
        imagePickerController.sourceType = .Camera
        imagePickerController.mediaTypes = [kUTTypeImage as String]
        imagePickerController.allowsEditing = false
        imagePickerController.showsCameraControls = true
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func displayImageGallery() {
        imagePickerController.sourceType = .PhotoLibrary
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func isCameraAvailable() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func doesCameraSupportTakingPhotos() -> Bool {
        return cameraSupportsMedia(kUTTypeImage as String, sourceType: .Camera)
    }
    
    func cameraSupportsMedia(mediaType: String, sourceType: UIImagePickerControllerSourceType) -> Bool {
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

    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toImageUploadViewController" {
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
            let imageUploadVC = segue.destinationViewController as! ImageUploadViewController
            imageUploadVC.pickedImage = (sender as! UIImage)
            imageUploadVC.token = token
            imageUploadVC.challengeID = challengeID
        }
    }
    
    
    
    
    
    func createPreviewImageView(image: UIImage) {
        
        let smallerViewSize: CGFloat!
        
        if view.bounds.width > view.bounds.height {
            smallerViewSize = view.bounds.height
        } else {
            smallerViewSize = view.bounds.width
        }
        
        
        
        
        
        
        
        
        print("\(image.size.width)")
        print("\(image.size.height)")
        
        print("\(view.bounds.width)")
        print("\(view.bounds.height)")
        
        
        let previewImageView: UIImageView!
        
        if image.size.width > image.size.height {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, view.bounds.width - 20.0, (view.bounds.width - 20.0) / (image.size.width / image.size.height)))
            
        } else if image.size.width < image.size.height {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, (view.bounds.width - 10.0) / (image.size.height / image.size.width), view.bounds.width - 20.0))
            
        } else {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, view.bounds.width - 20.0, view.bounds.width - 20.0))
        }
        
        previewImageView.contentMode = UIViewContentMode.ScaleAspectFit
        previewImageView.clipsToBounds = true
        previewImageView.image = image

        print("\(previewImageView.bounds.size.width)")
        print("\(previewImageView.bounds.size.height)")
        
        print("\(previewImageView.image?.size.width)")
        print("\(previewImageView.image?.size.height)")
        
        

        previewImageView.layer.cornerRadius = CGFloat(7.0)
        previewImageView.layer.borderWidth = CGFloat(1.0)
        previewImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
        previewImageView.clipsToBounds = true
        
        
        
        view.addSubview(previewImageView)
        previewImageView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.bringSubviewToFront(previewImageView)
        
        
    }
    

    
    
}


// MARK: - UIImagePickerControllerDelegate

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            pickedImage = image
            
            createPreviewImageView(pickedImage!)
            
//            previewImageView.image = image
//            previewImageView.hidden = false
            closeImageButton.hidden = false
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}



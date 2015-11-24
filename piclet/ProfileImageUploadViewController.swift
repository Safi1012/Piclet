//
//  ProfileImageUploadViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 24/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileImageUploadViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var closeImageButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var pickedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        styleImagePreview()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if !imagePickerController.isCameraAvailable() || !imagePickerController.doesCameraSupportTakingPhotos() {
            cameraButton.hidden = true
        } else {
            cameraButton.hidden = false
        }
    }
    
    
    // MARK: UI
    
    func styleImagePreview() {
        
        previewImageView.layer.backgroundColor = UIColor.clearColor().CGColor
        previewImageView.layer.cornerRadius = previewImageView.frame.width / 2.0
        previewImageView.layer.masksToBounds = true

        
        
//        previewImageView.layer.cornerRadius = CGFloat(7.0)
//        previewImageView.layer.borderWidth = CGFloat(1.0)
//        previewImageView.layer.borderColor = UIColor.darkGrayColor().CGColor
//        previewImageView.clipsToBounds = true
//        
//        func styleProfileButton() {
//            userProfileButton.layer.backgroundColor = UIColor.clearColor().CGColor
//            userProfileButton.layer.cornerRadius = userProfileButton.frame.width / 2.0
//            userProfileButton.layer.masksToBounds = true
//        }
//        
    }
    
    @IBAction func pressedCamera(sender: UIButton) {
        self.displayCamera(imagePickerController)
    }
    
    @IBAction func pressedCameraRoll(sender: UIButton) {
        self.displayImageGallery(imagePickerController)
    }
    
    @IBAction func pressedClosePreviewImage(sender: UIButton) {
        pickedImage = nil
        previewImageView.image = nil
        previewImageView.hidden = true
        closeImageButton.hidden = true
    }
    
    @IBAction func pressedCloseNavBarButton(sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}

// MARK: - UIImagePickerControllerDelegate

extension ProfileImageUploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            pickedImage = image
            previewImageView.image = image
            previewImageView.hidden = false
            closeImageButton.hidden = false
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

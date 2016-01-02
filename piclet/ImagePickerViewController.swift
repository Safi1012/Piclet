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
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    var imagePickerController = UIImagePickerController()
    var previewImageView: UIImageView?
    
    var token: String!
    var challengeID: String!
    var pickedImage: UIImage? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayCameraIconIfSupported()
        imagePickerController.delegate = self
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
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            sender.alpha = 0.0
            self.previewImageView?.alpha = 0.0
            
        }) { (value: Bool) -> Void in
            sender.removeFromSuperview()
            self.previewImageView?.removeFromSuperview()
            self.displayLabelAndButtons()
                
        }
    }
    
    @IBAction func pressedNextNavBarItem(sender: UIBarButtonItem) {
        if let pickedImage = pickedImage {
            performSegueWithIdentifier("toImageUploadViewController", sender: pickedImage)
        } else {
            displayAlert("NoPictureError")
        }
    }
    
    func displayCameraIconIfSupported() {
        if !self.isCameraAvailable() || !self.doesCameraSupportTakingPhotos() {
            cameraButton.hidden = true
        } else {
            cameraButton.hidden = false
        }
    }
    
    func getSmallerViewSize() -> CGFloat {
        if view.bounds.width > view.bounds.height {
            return view.bounds.height
        } else {
            return view.bounds.width
        }
    }
    
    func addRoundedBoarder(view: UIView) {
        view.layer.cornerRadius = CGFloat(7.0)
        view.layer.borderWidth = CGFloat(1.0)
        view.clipsToBounds = true
    }
    
    func addAndCenterSubview(subview: UIView) {
        view.addSubview(subview)
        subview.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    func hideLabelAndButtons() {
        descriptionLabel.hidden = true
        buttonView.hidden = true
    }
    
    func displayLabelAndButtons() {
        descriptionLabel.hidden = false
        buttonView.hidden = false
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
    
    
    // MARK: - PreviewImageView
    
    func createPreviewImageView(image: UIImage) -> UIImageView {
        
        let previewImageView: UIImageView!
        let smallerViewSize = getSmallerViewSize() - 20.0 // - 20.0 is for margin
        
        if image.size.width > image.size.height {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, smallerViewSize, smallerViewSize / (image.size.width / image.size.height)))
            
        } else if image.size.width < image.size.height {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, smallerViewSize / (image.size.height / image.size.width), smallerViewSize))
            
        } else {
            previewImageView = UIImageView(frame: CGRectMake(0.0, 0.0, smallerViewSize, smallerViewSize))
        }
        
        previewImageView.image = image
        addRoundedBoarder(previewImageView)
        addAndCenterSubview(previewImageView)
        
        return previewImageView
    }
    
    func createClosePreviewButton(previewImageView: UIImageView) {
        
        let closeButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        closeButton.addTarget(self, action: "pressedClosePreviewImage:", forControlEvents: UIControlEvents.TouchUpInside)
        closeButton.setImage(UIImage(named: "closeImageUnfilledRed"), forState: .Normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        
        
        // Constraints
        
        let views = ["subView": closeButton, "preview": previewImageView]
        let leftMargin = (view.bounds.width - previewImageView.bounds.width) / 2.0
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[subView]-\(leftMargin)-|", options: .AlignAllLeading, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[subView]-[preview]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        
        view.addConstraints(horizontalConstraints)
        view.addConstraints(verticalConstraints)
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
}


// MARK: - UIImagePickerControllerDelegate

extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        
            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            pickedImage = image
            hideLabelAndButtons()
            previewImageView = createPreviewImageView(image)
            createClosePreviewButton(previewImageView!)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}



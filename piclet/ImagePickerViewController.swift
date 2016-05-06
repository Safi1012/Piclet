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

    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePickerController = UIImagePickerController()
    var previewImageView: UIImageView?
    var challengeID: String!
    
    let MAX_IMAGE_PIXEL_SIZE = 10000000
    let MAX_IMAGE_SIZE_IN_BYTE = 3145728
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayCameraIconIfSupported()
        imagePickerController.delegate = self
    }
    

    // MARK: - UI
    
    @IBAction func pressedCamera(sender: UIButton) {
        imagePickerController.displayCamera(self)
    }
    
    @IBAction func pressedCameraRoll(sender: UIButton) {
        imagePickerController.displayImageGallery(self)
    }
    
    @IBAction func pressedClosePreviewImage(sender: UIButton) {
        
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            sender.alpha = 0.0
            self.previewImageView?.alpha = 0.0
            
        }) { (value: Bool) -> Void in
            sender.removeFromSuperview()
            self.previewImageView?.image = nil
            self.previewImageView?.removeFromSuperview()
            self.displayButtonView()
                
        }
    }
    
    @IBAction func pressedNextNavBarItem(sender: UIBarButtonItem) {
        guard
            let previewImageView = previewImageView,
            let previewImage = previewImageView.image
        else {
            displayAlert("NoPictureError")
            return
        }
        performSegueWithIdentifier("toImageUploadViewController", sender: previewImage)
    }
    
    func displayCameraIconIfSupported() {
        if imagePickerController.isCameraAvailableForUse() {
            cameraButton.hidden = false
        } else {
            cameraButton.hidden = true
        }
    }
    
    func getSmallerViewSize() -> CGFloat {
        if view.bounds.width > view.bounds.height {
            return view.bounds.height
        } else {
            return view.bounds.width
        }
    }
    
    func addRoundedBorder(view: UIView) {
        view.layer.cornerRadius = CGFloat(5.0)
        view.layer.borderWidth = CGFloat(1.0)
        view.clipsToBounds = true
    }
    
    func addAndCenterSubview(subview: UIView) {
        view.addSubview(subview)
        subview.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    }
    
    func hideButtonView() {
        buttonView.hidden = true
    }
    
    func displayButtonView() {
        buttonView.hidden = false
        buttonView.alpha = 0.0
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.buttonView.alpha = 1.0
        }
    }
    
    func validateImageData(image: UIImage) -> Bool {
        guard
            let compressedImage = ImageHandler().convertPostsImageForUpload(image, imageSize: ImagePostsServerWidth.large)
        else {
            self.displayAlert("IncompatibleImage")
            return false
        }
    
        if (image.size.width * image.size.height) >= CGFloat(MAX_IMAGE_PIXEL_SIZE) {
            self.displayAlert("ImagePixelTooBig")
            return false
        }
        if (image.size.width / image.size.height) > 3 || (image.size.width / image.size.height) < 0.3 {
            self.displayAlert("WrongAspectRatio")
            return false
        }
        if compressedImage.length >= MAX_IMAGE_SIZE_IN_BYTE {
            self.displayAlert("ImageTooBig")
            return false
        }
        return true
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
        addRoundedBorder(previewImageView)
        addAndCenterSubview(previewImageView)
        
        return previewImageView
    }
    
    func createClosePreviewButton(previewImageView: UIImageView) {
        
        let closeButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0))
        closeButton.addTarget(self, action: #selector(ImagePickerViewController.pressedClosePreviewImage(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
            
            if validateImageData(image) {
                hideButtonView()
                previewImageView = createPreviewImageView(image)
                createClosePreviewButton(previewImageView!)
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}



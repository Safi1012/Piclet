//
//  ProfileImageViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class ProfileImageViewController: UIViewController {

    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageButtonTopConstraint: NSLayoutConstraint!
    
    
    var username: String!
    var imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        getLoggedInUsername()
        styleProfileButton()
        loadUserProfileImage()
        setUsernameLabel()
    }
    
    func getLoggedInUsername() {
        
        if let username = UserAccess.sharedInstance.getUser()?.username {
            self.username = username
        } else {
            self.username = "Guest User"
        }
    }
    
    
    
    func getViewHeight() -> CGFloat {
        view.layoutIfNeeded()
        return profileImageButton.bounds.height + profileNameLabel.bounds.height + profileImageButtonTopConstraint.constant + 16.0
    }
    
    
    // MARK: UI
    
    func styleProfileButton() {
        profileImageButton.layer.backgroundColor = UIColor.clearColor().CGColor
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2.0
        profileImageButton.layer.masksToBounds = true
    }
    
    func loadUserProfileImage() {
        SDWebImageManager.sharedManager().imageDownloader.setValue("Bearer \(UserAccess.sharedInstance.getUser()!.token)", forHTTPHeaderField: "Authorization")
        let url = NSURL(string: "\(ServerAccess.sharedInstance.getServer()!.serverAddress)/users/\(username)/avatar-large.jpeg")
        profileImageButton.sd_setBackgroundImageWithURL(url, forState: .Normal, placeholderImage: UIImage(named: "userProfileRoundPlacholder"))
    }
    
    func setUsernameLabel() {
        profileNameLabel.text = username
    }
    
    @IBAction func pressedUserProfileButton(sender: UIButton) {
        if username != "Guest User" {
            createActionSheet()
        } else {
            displayAlert("NotLoggedIn")
        }
    }
    
    func displayNewUserImage(pickedImage: UIImage) {
        profileImageButton.setBackgroundImage(pickedImage, forState: .Normal)
    }
    

    // MARK: ActionSheet (Camera, Gallery)
    
    func createActionSheet() {
        let alertController = UIAlertController(title: "Choose your Picture", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        if imagePickerController.isCameraAvailableForUse() {
            alertController.addAction(addCameraAlertAction())
        }
        alertController.addAction(addImageGalleryAlertAction())
        alertController.addAction(UIAlertAction(title: "cancel", style: UIAlertActionStyle.Destructive, handler: nil))
        
        presentViewController(alertController, animated: true, completion: nil)
    }

    func addCameraAlertAction() -> UIAlertAction {
        return UIAlertAction(title: "Take Photo", style: .Default) { (UIAlertAction) -> Void in
            self.imagePickerController.displayCamera(self)
        }
    }
    
    func addImageGalleryAlertAction() -> UIAlertAction {
        return UIAlertAction(title: "Photo Library", style: .Default) { (UIAlertAction) -> Void in
            self.imagePickerController.displayImageGallery(self)
        }
    }
    
    
    // MARK: - Upload
    
    func uploadNewUserImage(pickedImage: UIImage) {
        
        if let user = UserAccess.sharedInstance.getUser() {
            let avatarImage = ImageHandler().convertAvatarImageForUpload(pickedImage, imageSize: ImageAvatarServerWidth.large)!
            displayNewUserImage(UIImage(data: avatarImage)!)
            
            ApiProxy().uploadUserProfileImage(user.username, image: avatarImage, success: { () -> () in
                SDWebImageManager.sharedManager().imageDownloader.setValue("Bearer \(UserAccess.sharedInstance.getUser()!.token)", forHTTPHeaderField: "Authorization")
                SDImageCache.sharedImageCache().storeImage(pickedImage, forKey: "\(ServerAccess.sharedInstance.getServer()!.serverAddress)/users/\(user.username)/avatar-large.jpeg", toDisk: true)
                
            }) { (errorCode) -> () in
                self.loadUserProfileImage()
                self.displayAlert(errorCode)
                    
            }
            
        } else {
            displayAlert("NotLoggedIn")
            
        }
    }
}


// MARK: - UIImagePickerControllerDelegate

extension ProfileImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            if picker.sourceType == UIImagePickerControllerSourceType.Camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
            displayNewUserImage(image)
            uploadNewUserImage(image)
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

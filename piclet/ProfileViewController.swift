//
//  ProfileViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 06/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logutNavbarButton: UIBarButtonItem!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var token: String?
    var userName: String?
    var imagePickerController = UIImagePickerController()

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        
        fetchLoggedInUser()
        updateUserUI()
        styleProfileButton()
    }
    
    func fetchLoggedInUser() {
        if let loggedInUser = User.getLoggedInUser(AppDelegate().managedObjectContext) {
            if let userToken = loggedInUser.token, let userName = loggedInUser.username {
                self.token = userToken
                self.userName = userName
            }
        }
    }
    
    func updateUserUI() {
        if let userName = self.userName {
            refreshUserProfileImage(userName)
            createNavbarButton("Logout", action: "pressedLogoutNavbarButton:")
        } else {
            createNavbarButton("Login/Signup", action: "pressedLoginNavbarButton:")
        }
    }
    

    
    // MARK: - UI
    
    func createNavbarButton(buttonTitle: String, action: String) {
        let logoutNavbarItem = UIBarButtonItem(title: buttonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(action))
        logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = logoutNavbarItem
    }
    
    func pressedLogoutNavbarButton(sender: UIBarButtonItem) {
        
        ApiProxy().deleteThisUserToken(token!, success: { () -> () in
            User.removeUserToken(AppDelegate().managedObjectContext)
            self.navigatoToLoginViewController()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToLoginViewController()
    }
    
    func styleProfileButton() {
        userProfileButton.layer.backgroundColor = UIColor.clearColor().CGColor
        userProfileButton.layer.cornerRadius = userProfileButton.frame.width / 2.0
        userProfileButton.layer.masksToBounds = true
    }
    
    
    // needs to be tested
    func refreshUserProfileImage(username: String) {
        let url = NSURL(string: "https://flash1293.de/users/\(username)/avatar-large.jpeg")
        
        
        // use block instead
        let imageView = UIImageView()
        imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "userProfileRoundPlacholder"))
        
        userProfileButton.setImage(imageView.image!, forState: UIControlState.Normal)
    }
    
    @IBAction func userPressedProfileImage(sender: UIButton) {
        createActionSheet()
    }

    func createActionSheet() {
        let alertController = UIAlertController(title: "Choose your Picture", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let cameraAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.displayCamera(self.imagePickerController)
        }
        let imageGalleryAction = UIAlertAction(title: "Photo Library", style: UIAlertActionStyle.Default) { (UIAlertAction) -> Void in
            self.displayImageGallery(self.imagePickerController)
        }
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Destructive, handler: nil)
        
        if imagePickerController.isCameraAvailable() && imagePickerController.doesCameraSupportTakingPhotos() {
            alertController.addAction(cameraAction)
        }
        alertController.addAction(imageGalleryAction)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func displayNewUserImage(pickedImage: UIImage) {
        userProfileButton.setImage(pickedImage, forState: UIControlState.Normal)
    }
    
    
    // MARK: - Upload
    
    func uploadNewUserImage(pickedImage:UIImage) {
        guard
            let token = token,
            let userName = userName
        else {
            displayAlert("NotLoggedIn")
            return
        }
        let avatarImage = ImageHandler().convertAvatarImageForUpload(pickedImage, imageSize: ImageAvatarServerWidth.large)!
        
        
        ApiProxy().uploadUserProfileImage(token, username: userName, image: avatarImage, success: { () -> () in
            print("Succesfully")
            // invalidate image cache!
            
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
            // displayOldImage...
            
        }
    }
    
    
    
    
    // MARK: - Navigation
    
    func navigatoToLoginViewController() {
        
        dispatch_async(dispatch_get_main_queue()) {
            if (UIApplication.sharedApplication().delegate as! AppDelegate).loginViewController != nil {
                self.performSegueWithIdentifier("unwindToLoginViewController", sender: self)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewControllerWithIdentifier("LoginViewController")
                self.presentViewController(loginVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {}
}


// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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

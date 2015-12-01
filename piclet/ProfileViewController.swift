//
//  ProfileViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 06/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var logutNavbarButton: UIBarButtonItem!
    @IBOutlet weak var userProfileButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var userProfileHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var userProfileWidthConstraint: NSLayoutConstraint!
    
    
    var userAccount: UserAccount?
    var imagePickerController = UIImagePickerController()
    var selectedProfileStat: SelectedProfileStat?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        fetchUserInformation()
    }
    
    
    // MARK: - User Information
    
    func fetchUserInformation() {
        
        ApiProxy().fetchUserAccountInformation({ (userAccount) -> () in
            self.userAccount = userAccount
            
            self.displayUserLabel(userAccount.username)
            self.displayUserProfileImage(userAccount.username)
            self.displayUserTableView()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            self.displaySignupInformation()
            
        }
    }
    
    func displaySignupInformation() {
        createNavbarButton("Login/Signup", action: "pressedLoginNavbarButton:")
    }
    
    func displayUserLabel(username: String) {
        userNameLabel.hidden = false
        userNameLabel.text = username
        createNavbarButton("Logout", action: "pressedLogoutNavbarButton:")
    }
    
    func displayUserProfileImage(username: String) {
        styleProfileButton()
        userProfileButton.hidden = false
        refreshUserProfileImage(username)
    }
    
    func displayUserTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.hidden = false
        
        tableView.reloadData()
    }
    

    
    
    

    
    
    
    
    
    // MARK: - Navbar
    
    func createNavbarButton(buttonTitle: String, action: String) {
        let logoutNavbarItem = UIBarButtonItem(title: buttonTitle, style: UIBarButtonItemStyle.Plain, target: self, action: Selector(action))
        logoutNavbarItem.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = logoutNavbarItem
    }
    
    func pressedLogoutNavbarButton(sender: UIBarButtonItem) {
        
        ApiProxy().deleteThisUserToken(userAccount!.token, success: { () -> () in
            User.removeUserToken(AppDelegate().managedObjectContext)
            self.navigatoToLoginViewController()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func pressedLoginNavbarButton(sender: UIBarButtonItem) {
        navigatoToLoginViewController()
    }
    
    
    // MARK: - UI
    
    func refreshUserProfileImage(username: String) {
        let url = NSURL(string: "https://flash1293.de/users/\(username)/avatar-large.jpeg")
        userProfileButton.sd_setImageWithURL(url, forState: UIControlState.Normal, placeholderImage: UIImage(named: "userProfileRoundPlacholder"))
    }
    
    func styleProfileButton() {
        let imageSize: CGFloat!
        
        switch (UIScreen().getDisplayInchSize()) {

        case DeviceInchSize.inch_3_5:
            imageSize = 74.0

        case DeviceInchSize.inch_4_0:
            imageSize = 150.0

        case DeviceInchSize.inch_4_7, DeviceInchSize.inch_5_5:
            imageSize = 200.0
        }
        userProfileHeightContraint.constant = imageSize
        userProfileWidthConstraint.constant = imageSize
        userProfileButton.layer.bounds.size = CGSize(width: imageSize, height: imageSize)
        
        userProfileButton.layer.backgroundColor = UIColor.clearColor().CGColor
        userProfileButton.layer.cornerRadius = userProfileButton.frame.width / 2.0
        userProfileButton.layer.masksToBounds = true
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
    
    
    // MARK: - Userstats
    
//    func fetchUserCreatedPosts() {
//        ApiProxy().fetchUserCreatedPosts(userAccount!.username, success: { (userPosts) -> () in
//            
//            // call function in profileCollectionViewController
//            
//        }) { (errorCode) -> () in
//            self.displayAlert(errorCode)
//            
//        }
//    }
    
    
    
    // MARK: - Upload
    
    func uploadNewUserImage(pickedImage:UIImage) {
        guard
            let token = userAccount?.token,
            let userName = userAccount?.username
        else {
            displayAlert("NotLoggedIn")
            return
        }
        
        let avatarImage = ImageHandler().convertAvatarImageForUpload(pickedImage, imageSize: ImageAvatarServerWidth.large)!
        
        ApiProxy().uploadUserProfileImage(token, username: userName, image: avatarImage, success: { () -> () in
            SDImageCache.sharedImageCache().storeImage(pickedImage, forKey: "https://flash1293.de/users/\(userName)/avatar-large.jpeg", toDisk: true)
            
        }) { (errorCode) -> () in
            self.refreshUserProfileImage(userName)
            self.displayAlert(errorCode)
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let selectedProfileStat = selectedProfileStat {
            let destinationVC = segue.destinationViewController as! ProfileCollectionViewController
            destinationVC.selectedProfileStat = selectedProfileStat
        }
    }
    
    @IBAction func unwindToProfileViewController(segue: UIStoryboardSegue) {}
}


// MARK: - UITableViewDataSource

extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if userAccount != nil {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userAccount != nil {
            return 2
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if indexPath.section == 0 {
            
            switch (indexPath.row) {
            case 0:
                cell.textLabel?.text = "Rank"
                cell.detailTextLabel?.text = "\(userAccount!.rank)"
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryType = UITableViewCellAccessoryType.None
                
            case 1:
                cell.textLabel?.text = "Likes"
                cell.detailTextLabel?.text = "\(userAccount!.totalVotes)"
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryType = UITableViewCellAccessoryType.None
                
            default:
                print("ErrorTableProfileTab")
            }
        }
        if indexPath.section == 1 {
            
            switch (indexPath.row) {
            case 0:
                cell.textLabel?.text = "Posts"
                cell.detailTextLabel?.text = "\(userAccount!.totalPosts)"
                
            case 1:
                cell.textLabel?.text = "Challenges"
                cell.detailTextLabel?.text = "Tutum.."
                
            default:
                print("ErrorTableProfileTab")
            }
        }
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Stats"
            
        case 1:
            return "Uploads"
            
        default:
            return ""
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch (indexPath.row) {
        case 0:
            print("rank")
            
        case 1:
            print("totalLikes")
            selectedProfileStat = SelectedProfileStat.Likes
            
        case 2:
            print("totalPosts")
            selectedProfileStat = SelectedProfileStat.Posts
            
        default:
            print("ErrorTableProfileTab didSelectRowAtIndexPath")
        }
        performSegueWithIdentifier("toProfileCollectionView", sender: self)
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        let sectionHeight: TableSectionHeight!
        
        switch (UIScreen().getDisplayInchSize()) {
            
        case DeviceInchSize.inch_3_5:
            sectionHeight = TableSectionHeight.small
            
        case DeviceInchSize.inch_4_0:
            sectionHeight = TableSectionHeight.medium
            
        case DeviceInchSize.inch_4_7, DeviceInchSize.inch_5_5:
            sectionHeight = TableSectionHeight.large
        }
        if section == 0 {
            return TableSectionHeight.first.rawValue
        }
        return sectionHeight.rawValue
    }
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


// MARK: - TableSectionHeight

enum TableSectionHeight: CGFloat {
    case first = 0.01
    case small = 18.0
    case medium = 30.0
    case large = 35.0
}


//
//  ProfileCollectionViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 25/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class ProfileCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var editBarButtonItem: UIBarButtonItem!
    
    var userAccount: UserAccount!
    var userPostIds: [PostInformation] = []
    var selectedPostIds: [PostInformation] = []
    var downloadUserCreatedPosts = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        if downloadUserCreatedPosts {
            navigationItem.title = "Your Posts"
        } else {
            navigationItem.title = "Liked Posts"
        }
        fetchPosts(0)
    }
    
    
    // Handle Data
    
    func fetchPosts(offset: Int) {
        if downloadUserCreatedPosts {
            fetchUserCreatedPosts(offset)
        } else {
            fetchUserLikedPosts(offset)
        }
    }
    
    func fetchUserCreatedPosts(offset: Int) {
        ApiProxy().fetchUserCreatedPosts(userAccount.username, offset: offset, success: { (userPosts) -> () in
            
            self.userPostIds = userPosts
            
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView?.reloadData()
            })
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func fetchUserLikedPosts(offset: Int) {
        ApiProxy().fetchLikedPosts(offset, success: { (posts) -> () in
            
            if offset == 0 {
                self.userPostIds = [PostInformation]()
            }
            for postId in posts {
                self.userPostIds.append(postId)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.collectionView?.reloadData()
            })

        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func deleteUserPost() {
        showLoadingSpinner(UIOffset())
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let group = dispatch_group_create();
        
        for postInformation in selectedPostIds {
            dispatch_group_enter(group)
            
            ApiProxy().deleteUserPost(userAccount.token, challengeID: postInformation.challengeId, postID: postInformation.postId, success: { () -> () in
                dispatch_group_leave(group)
                
            }, failure: { (errorCode) -> () in
                dispatch_group_leave(group)
                self.displayAlert(errorCode)
                    
            })
        }
        
        dispatch_group_notify(group, queue) { () -> Void in
            self.dismissLoadingSpinner()
            self.selectedPostIds = []
            self.fetchPosts(0)
        }
    }
    
    func animateNavigationBarTitle(title: String, barButton: UIBarButtonItem) {
        let fadeTextAnimation = CATransition()
        fadeTextAnimation.duration = 0.45
        fadeTextAnimation.type = kCATransitionFade
        
        dispatch_async(dispatch_get_main_queue(),{
            self.navigationController?.navigationBar.layer.addAnimation(fadeTextAnimation, forKey: "fadeText")
            barButton.title = title
        })
    }
    
    
    // User
    
    @IBAction func userPressedEditButton(sender: UIBarButtonItem) {
        
        switch (sender.title!) {
            
        case "Edit":
            animateNavigationBarTitle("Cancel", barButton: sender)
            collectionView?.allowsMultipleSelection = true
            
        case "Cancel":
            animateNavigationBarTitle("Edit", barButton: sender)
            collectionView?.allowsMultipleSelection = false
            
        case "Delete":
            animateNavigationBarTitle("Edit", barButton: sender)
            collectionView?.allowsMultipleSelection = false
            deleteUserPost()
            
        default:
            print("Right NavigationButton has an unknown Title")
            
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return userPostIds.count > 0 ? 1 : 0
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPostIds.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        let url = "https://flash1293.de/challenges/\(userPostIds[indexPath.row].challengeId)/posts/\(userPostIds[indexPath.row].postId)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        cell.newImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "grayPlaceholder"))
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if editBarButtonItem.title == "Edit" {
            let imageView = UIImageView()
            let url = "https://flash1293.de/challenges/\(userPostIds[indexPath.row].challengeId)/posts/\(userPostIds[indexPath.row].postId)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "grayPlaceholder"))
            
            let imageInfo = JTSImageInfo()
            imageInfo.image = imageView.image
            
            let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
            imageViewer.optionsDelegate = self
            imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOffscreen)
            
        } else {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
            cell.layer.borderWidth = 6.0
            cell.layer.borderColor = UIColor(red: 0.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
            
            if editBarButtonItem.title == "Cancel" {
                animateNavigationBarTitle("Delete", barButton: editBarButtonItem)
            }
            selectedPostIds.append(PostInformation(postId: userPostIds[indexPath.row].postId, challengeId: userPostIds[indexPath.row].challengeId))
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
        cell.layer.borderWidth = 0.0
        
        for var i = 0; i < selectedPostIds.count; i++ {
            if selectedPostIds[i].postId == userPostIds[indexPath.row].postId && selectedPostIds[i].challengeId == userPostIds[indexPath.row].challengeId {
                selectedPostIds.removeAtIndex(i)
            }
        }
        
        if selectedPostIds.count == 0 {
            animateNavigationBarTitle("Cancel", barButton: editBarButtonItem)
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (UIScreen.mainScreen().bounds.width / 3.0) - 0.55 // should be 0.5, iPhone 5S Simulator bug. Test on hardware
        
        if (indexPath.row - 1) % 3 == 0 {
            return CGSizeMake(width - 0.5, width)
        }
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1.0, left: 0.0, bottom: 1.0, right: 0.0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
//
//        if (maximumOffset - currentOffset) <= 70 {
//            fetchPosts((userPostIds.count - 20) + 20)
//        }
//    }
    
}


// MARK: JTSImageViewControllerOptionsDelegate

extension ProfileCollectionViewController: JTSImageViewControllerOptionsDelegate {
    
    func backgroundColorImageViewInImageViewer(imageViewer: JTSImageViewController) -> UIColor {
        return UIColor.blackColor()
    }
    
    func alphaForBackgroundDimmingOverlayInImageViewer(imageViewer: JTSImageViewController) -> CGFloat {
        return 1.0
    }
}

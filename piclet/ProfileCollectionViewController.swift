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
    var selectedPosts: [SelectedPost] = []
    var downloadUserCreatedPosts = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
    }
    
    override func viewWillAppear(animated: Bool) {
        if downloadUserCreatedPosts {
            navigationItem.title = "Your Posts"
        } else {
            navigationItem.title = "Liked Posts"
            navigationItem.setRightBarButtonItem(nil, animated: true)
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
        self.removeCentered(self.collectionView!)
        
        ApiProxy().fetchUserCreatedPosts(userAccount.username, offset: offset, success: { (userPosts) -> () in
            
            if offset == 0 {
                self.userPostIds = [PostInformation]()
            }
            for postId in userPosts {
                self.userPostIds.append(postId)
            }
            if self.userPostIds.count == 0 {
                self.addCenteredLabel("You don't have any posts. \n Let's go and create some!", view: self.collectionView!)
                self.view.viewWithTag(1)?.center.y -= 30
                
            } else {
                self.removeCentered(self.collectionView!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                    self.collectionView?.viewWithTag(2)?.stopAnimatingIndicatorView()
                })
                
            }
            
        }) { (errorCode) -> () in
            self.collectionView?.viewWithTag(2)?.stopAnimatingIndicatorView()
            self.displayAlert(errorCode)
            
        }
    }
    
    func fetchUserLikedPosts(offset: Int) {
        self.removeCentered(self.collectionView!)
        
        ApiProxy().fetchLikedPosts(offset, success: { (posts) -> () in
            
            if offset == 0 {
                self.userPostIds = [PostInformation]()
            }
            for postId in posts {
                self.userPostIds.append(postId)
            }
            if self.userPostIds.count == 0 {
                self.addCenteredLabel("You didn't like any posts. \n Let's go and share some ♥️", view: self.collectionView!)
                self.view.viewWithTag(1)?.center.y -= 30
                
            } else {
                self.removeCentered(self.collectionView!)
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                    self.collectionView?.viewWithTag(2)?.stopAnimatingIndicatorView()
                })
                
            }

        }) { (errorCode) -> () in
            self.collectionView?.viewWithTag(2)?.stopAnimatingIndicatorView()
            self.displayAlert(errorCode)
            
        }
    }
    
    func deleteUserPost() {
        showLoadingSpinner(UIOffset(), color: UIColor.blackColor())
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        let group = dispatch_group_create();
        
        for selectedPost in selectedPosts {
            dispatch_group_enter(group)
            
            ApiProxy().deleteUserPost(selectedPost.challengeID, postID: selectedPost.postID, success: { () -> () in
                dispatch_group_leave(group)
                
            }, failure: { (errorCode) -> () in
                dispatch_group_leave(group)
                self.displayAlert(errorCode)
                    
            })
        }
        dispatch_group_notify(group, queue) { () -> Void in
            self.dismissLoadingSpinner()
            self.removeDeleteMarkers()
            self.selectedPosts = []
            self.fetchPosts(0)
        }
    }

    
    // User
    
    @IBAction func userPressedEditButton(sender: UIBarButtonItem) {
        
        switch (sender.title!) {
            
        case "Edit":
            animateNavigationBarTitle("Cancel", barButton: sender)
            collectionView?.allowsMultipleSelection = true
            navigationItem.title = "Select to Delete"
            
        case "Cancel":
            animateNavigationBarTitle("Edit", barButton: sender)
            collectionView?.allowsMultipleSelection = false
            navigationItem.title = "Your Posts"
            
        case "Delete":
            deleteUserPost()
            animateNavigationBarTitle("Edit", barButton: sender)
            collectionView?.allowsMultipleSelection = false
            navigationItem.title = "Your Posts"
            
        default:
            print("Right NavigationButton has an unknown Title")
            
        }
    }
    
    func addDeleteMarker(indexPath: NSIndexPath) {
        let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
        cell.layer.borderWidth = 6.0
        cell.layer.borderColor = UIColor(red: 0.0, green: 125.0/255.0, blue: 255.0/255.0, alpha: 1.0).CGColor
        
        if editBarButtonItem.title == "Cancel" {
            animateNavigationBarTitle("Delete", barButton: editBarButtonItem)
        }
        selectedPosts.append(SelectedPost(indexPath: indexPath, postID: userPostIds[indexPath.row].postId, challengeID: userPostIds[indexPath.row].challengeId))
    }
    
    func removeDeleteMarkers() {
        for selctedPost in selectedPosts {
            let cell = self.collectionView?.cellForItemAtIndexPath(selctedPost.indexPath) as! ProfileCollectionViewCell
            cell.layer.borderWidth = 0.0
        }
    }
    
    func showPostInFullscreen(indexPath: NSIndexPath) {
        let imageView = UIImageView()
        let url = "https://flash1293.de/challenges/\(userPostIds[indexPath.row].challengeId)/posts/\(userPostIds[indexPath.row].postId)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "grayPlaceholder"))
        
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageView.image
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
        imageViewer.optionsDelegate = self
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOffscreen)
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
        if downloadUserCreatedPosts {
            if editBarButtonItem.title == "Edit" {
                showPostInFullscreen(indexPath)
                
            } else {
                addDeleteMarker(indexPath)
                
            }
            
        } else {
            showPostInFullscreen(indexPath)
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ProfileCollectionViewCell
        cell.layer.borderWidth = 0.0
        
        if selectedPosts.count - 1 == 0 {
            animateNavigationBarTitle("Cancel", barButton: editBarButtonItem)
        }
        
        for i in (0...selectedPosts.count - 1).reverse() {
            if selectedPosts[i].indexPath == indexPath {
                selectedPosts.removeAtIndex(i)
                return
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionFooter) {
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath)
            footerView.addActivityIndicatorSubview()
            footerView.tag = 2
            
            return footerView
        }
        return UICollectionReusableView()
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
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.mainScreen().bounds.width, height: 70.0)
    }
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if (maximumOffset - currentOffset) <= 70 {
            self.collectionView?.viewWithTag(2)?.startAnimatingIndicatorView()
            fetchPosts((userPostIds.count - 20) + 20)
        }
    }
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


// MARK: SelectedPost

struct SelectedPost {
    var indexPath: NSIndexPath!
    var postID: String!
    var challengeID: String!
}


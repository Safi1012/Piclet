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
    
    @IBOutlet weak var tileImageView: UIImageView!
    var userAccount: UserAccount!
    var userPostIds: [PostInformation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        fetchUserCreatedPosts()
    }
    
    func fetchUserCreatedPosts() {
        ApiProxy().fetchUserCreatedPosts(userAccount.username, success: { (userPosts) -> () in
            self.userPostIds = userPosts
            self.collectionView?.reloadData()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
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
        cell.newImage.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "challengePreviewPlaceholder"))
        
        return cell
    }

    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
}


extension ProfileCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = (UIScreen.mainScreen().bounds.width / 3.0) - 0.5
        
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
}




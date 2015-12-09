//
//  ProfileCollectionViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 25/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

private let reuseIdentifier = "Cell"

class ProfileCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var tileImageView: UIImageView!
    var userAccount: UserAccount!
    var userPostIds: [PostInformation] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calculateTileSize()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
//         self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProfileCollectionViewCell
        
        print("\(userPostIds[indexPath.row].challengeId)")
        print("\(userPostIds[indexPath.row].postId)")
        
        cell.backgroundColor = UIColor.greenColor()
        
        
//        cell.newImage = UIImageView()
//        
//        print("\(cell.newImage)")
//        cell.newImage = UIImageView(image: UIImage(named: "challengePreviewPlaceholder"))
//        print("\(cell.newImage)")
        
        
        // cell.newImage.image = UIImage(named: "challengePreviewPlaceholder")
        
        
        // cell.imageView.image = UIImage(named: "challengePreviewPlaceholder")
        
//        let url = "https://flash1293.de/challenges/\(userPostIds[indexPath.row].challengeId)/posts/\(userPostIds[indexPath.row].postId)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
//
//        
//        let test = NSURL(string: url)
//        print("\(cell.imageView)")
//        print("\(cell.imageView.image?.size.height)")
//        
//        
//        
//        
//        cell.imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "challengePreviewPlaceholder"))
        
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
        let width = (UIScreen.mainScreen().bounds.width / 3.0) - 1.0
        return CGSize(width: width, height: width)
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




//
//  PostsViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 23/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import WebImage

class PostsViewController: UIViewController {
    
    @IBOutlet weak var mascotView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var challenge: Challenge!
    var posts = [Post]()
    
    private var aspectRatios = NSDictionary()
    private var isRequesting = false
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = challenge.title
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        self.viewDidAppear(animated)
        
        hideAddNavButton()
        fetchAllPostInformations()
    }

    
    // MARK: - UI
    
    func reloadTableView() {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func setButtonImage(button: UIButton, imageName: String) {
        dispatch_async(dispatch_get_main_queue(), {
            button.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        })
    }
    
    @IBAction func userPressedMascot(sender: UIButton) {
        userPressedCreatePost()
    }
    
    @IBAction func pressedCreatePost(sender: UIBarButtonItem) {
        
        if !checkIfUserAlreadyPosted() {
            userPressedCreatePost()
        } else {
            displayAlert("AlreadyPostedError")
        }
    }
    
    func displayMascotView() {
        tableView.hidden = true
        mascotView.hidden = false
    }
    
    func displayTableView() {
        tableView.hidden = false
        mascotView.hidden = true
    }
    
    func hideAddNavButton() {
        if challenge.archived! {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    

    // MARK: - Posts
    
    func fetchAllPostInformations() {
        fetchAllPostsAspectRatios {
            self.fetchAllPostsMetaData({ 
                self.tableView.performSelectorOnMainThread(#selector(UITableView.reloadData), withObject: nil, waitUntilDone: true)
            })
        }
    }
    
    func fetchAllPostsAspectRatios(success: () -> ()) {
        ApiProxy().fetchAspectRatios(challenge.id, success: { (aspectRatios) in
            self.aspectRatios = aspectRatios
            success()
            
        }) { (errorCode) in
            self.displayAlert(errorCode)
            
        }
    }
    
    func fetchAllPostsMetaData(success: () -> ()) {
        ApiProxy().fetchChallengePosts(challenge.id, success: { (posts) -> () in
            self.posts = posts
            
            if self.posts.count > 0 {
                self.displayTableView()
                
            } else {
                self.displayMascotView()
            }
            success()
            
        }) { (errorCode) -> () in
            self.displayAlert(errorCode)
            
        }
    }
    
    func likeChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().likePost(challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
        }) { (errorCode) -> () in
            post.votes! -= 1
            cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "vote")
            self.isRequesting = false
            self.displayAlert(errorCode)
            
        }
    }
    
    func revertChallengePost(post: Post, cell: PostsTableViewCell, token: String) {
        
        ApiProxy().revertLikePost(challenge.id, postID: post.id, success: { () -> () in
            self.isRequesting = false
            
        }) { (errorCode) -> () in
            post.votes! += 1
            cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "vote")
            self.isRequesting = false
            self.displayAlert(errorCode)
            
        }
    }
    
    func userPressedCreatePost() {

        if UserAccess.sharedInstance.isUserLoggedIn() {
            displayTableView()
//            performSegueWithIdentifier("toImagePickerViewController", sender: self)
            
            
            let postCreateNavigationVC = UIStoryboard.init(name: "PostCreate", bundle: nil).instantiateInitialViewController() as! UINavigationController
            let imagePickerVC = (postCreateNavigationVC.viewControllers[0] as! ImagePickerViewController)
            
            imagePickerVC.challengeID = challenge.id
            
            presentViewController(postCreateNavigationVC, animated: true, completion: nil)
            
        } else {
            self.displayAlert("NotLoggedIn")
            
        }
    }
    
    func checkIfUserAlreadyPosted() -> Bool {
        
        if let user = UserAccess.sharedInstance.getUser() {
            for post in posts {
                if post.creator == user.username {
                    return true
                }
            }
        }
        return false
    }
    

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toImagePickerViewController" {
            let destinationVC = (segue.destinationViewController as! UINavigationController).viewControllers[0] as! ImagePickerViewController
            destinationVC.challengeID = challenge.id
        }
    }
    
    @IBAction func unwindToPostTableViewController(segue: UIStoryboardSegue) {}
}


// MARK: - UITableViewDataSource

extension PostsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        SDWebImageManager.sharedManager().imageDownloader.setValue("Bearer \(UserAccess.sharedInstance.getUser()!.token)", forHTTPHeaderField: "Authorization")
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostsTableViewCell
        let url = "\(ServerAccess.sharedInstance.getServer()!.serverAddress)/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        
        challenge.archived! ? [cell.postLikeButton.hidden = true] : [cell.postLikeButton.hidden = false]
        cell.post = posts[indexPath.row]
        cell.delegate = self
        cell.addDoubleTapGestureRecognizer(self)
        cell.postDescriptionLabel.text = posts[indexPath.row].description
        cell.postVotesLabel.text = Formater().formatSingularAndPlural(posts[indexPath.row].votes, singularWord: "vote")
        cell.postUsernameLabel.text = posts[indexPath.row].creator
        cell.postTimeLabel.text = TimeHandler().getPostedTimestampFormated(posts[indexPath.row].posted)
        cell.postImage.contentMode = UIViewContentMode.ScaleAspectFit
        cell.postImage.clipsToBounds = true
        cell.postImage.sd_setImageWithURL(NSURL(string: url))
        
        if let user = UserAccess.sharedInstance.getUser() {
            for username in posts[indexPath.row].voters {
                if username == user.username {
                    cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                    break
                }
            }
        }
        return cell
    }
}


// MARK: - UITableViewDelegate

extension PostsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SDWebImageManager.sharedManager().imageDownloader.setValue("Bearer \(UserAccess.sharedInstance.getUser()!.token)", forHTTPHeaderField: "Authorization")
        let imageView = UIImageView()
        let url = "\(ServerAccess.sharedInstance.getServer()!.serverAddress)/challenges/\(challenge.id)/posts/\(posts[indexPath.row].id)/image-\(ImageSize.medium).\(ImageFormat.jpeg)"
        imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "grayPlaceholder"))
        
        let imageInfo = JTSImageInfo()
        imageInfo.image = imageView.image
        
        let imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Blurred)
        imageViewer.optionsDelegate = self
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition.FromOffscreen)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let aspectRatio = aspectRatios[posts[indexPath.row].id] as? Double {
            return (UIScreen.mainScreen().bounds.width / CGFloat(aspectRatio)) + 67
        } else {
            return UIScreen.mainScreen().bounds.width + 67
        }
    }
}


// MARK: - PostsTableViewDelegate

extension PostsViewController: PostsTableViewDelegate {
    
    func likeButtonInCellWasPressed(cell: PostsTableViewCell, post: Post) {
        
        if let user = UserAccess.sharedInstance.getUser() {
            if isRequesting {
                return
            }
            isRequesting = true
            
            if cell.postLikeButton.imageForState(UIControlState.Normal) == UIImage(named: "likeFilled") {
                post.votes! -= 1
                cell.postLikeButton.setImage(UIImage(named: "likeUnfilled"), forState: UIControlState.Normal)
                revertChallengePost(post, cell: cell, token: user.token)
                
            } else {
                post.votes! += 1
                cell.postLikeButton.setImage(UIImage(named: "likeFilled"), forState: UIControlState.Normal)
                likeChallengePost(post, cell: cell, token: user.token)
                
            }
            
            // check if neccesary
            cell.postVotesLabel.text = Formater().formatSingularAndPlural(post.votes, singularWord: "vote")
        }
    }
}


// MARK: - JTSImageViewControllerOptionsDelegate

extension PostsViewController: JTSImageViewControllerOptionsDelegate {
    
    func backgroundColorImageViewInImageViewer(imageViewer: JTSImageViewController) -> UIColor {
        return UIColor.blackColor()
    }
    
    func alphaForBackgroundDimmingOverlayInImageViewer(imageViewer: JTSImageViewController) -> CGFloat {
        return 1.0
    }
}

//
//  ChallengeTableViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ChallengeTableViewController: UITableViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let apiProxy = ApiProxy()
    var challenges = [Challenge]()
    let loadingProgressViewController = LoadingProgressViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // invalidator after 5 min
        
        showLoadingSpinner()

        apiProxy.getChallenges(nil, offset: "10", success: { (challenges) -> () in
            self.hideLoadingSpinner()
            self.challenges = challenges
                
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            self.displayAlert(ErrorHandler().createErrorAlert(errorCode))
        }
    }
    
    
    
    // MARK: - UI
    
    func showLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            let loadingSpinner = MBProgressHUD.showHUDAddedTo(self.tableView.superview, animated: true)
            loadingSpinner.labelText = "Loading Data"
        })
    }
    
    func hideLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.tableView.superview, animated: true)
        })
    }
    
    func displayAlert(alertController: UIAlertController) {
        dispatch_async(dispatch_get_main_queue(), {
            self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return challenges.count == 0 ? 0 : 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell
        
        cell.titleLabel.text = challenges[indexPath.row].title
        cell.timePostedLabel.text = challenges[indexPath.row].posted ?? "0" + " min"
        cell.votesLabel.text = challenges[indexPath.row].votes ?? "0" + " votes"
        cell.previewImageView.image = UIImage(named: "challengePreviewPlaceholder")
        
        return cell
    }
}

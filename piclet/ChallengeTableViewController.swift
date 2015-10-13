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

    override func viewWillAppear(animated: Bool) {
        
        
        // invalidator after 5 min
        
        showLoadingSpinner()
        
        
        apiProxy.getChallenges(nil, offset: "10", success: { (challenges) -> () in
            self.hideLoadingSpinner()
            self.challenges = challenges
            self.tableView.reloadData()
        }) { (errorCode) -> () in
            self.hideLoadingSpinner()
            
            
            
            print("Failed")
        }
    }
    
    
    
    
    // MARK: - UI
    
    func showLoadingSpinner() {
        let loadingSpinner = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingSpinner.labelText = "Loading Data"
    }
    
    func hideLoadingSpinner() {
        dispatch_async(dispatch_get_main_queue(), {
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        })
    }
    

    


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 //challenges.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChallengeTableViewCell

//        cell.titleLabel.text = challenges[indexPath.row].title
//        cell.timePostedLabel.text = "2 min ago" // challenges[indexPath.row].posted
//        // cell.votesLabel.text = "TTT" //challenges[indexPath.row].votes
//        cell.previewImageView.image = UIImage(named: "challengePreviewPlaceholder")
        
        return cell
    }

//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Fehler"
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

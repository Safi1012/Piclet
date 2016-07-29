//
//  UITableViewControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 16/06/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import UIKit

// MARK: - Extends the UITableViewController class
extension UITableViewController {

    /**
     Calculate the tables view height
     
     - returns: the table view height in CGFLoat
     */
    func getTableViewHeight() -> CGFloat {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        
        return tableView.contentSize.height
    }
}
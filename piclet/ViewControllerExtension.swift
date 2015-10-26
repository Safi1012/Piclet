
//
//  ViewControllerExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 26/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit
import Foundation

var refreshControl = UIRefreshControl()

extension UIViewController {
    
    func makePullToRefreshToTableView(tableName: UITableView,triggerToMethodName: String) {
        refreshControl.attributedTitle = NSAttributedString(string: "Loading")
        refreshControl.backgroundColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: Selector(triggerToMethodName), forControlEvents: UIControlEvents.ValueChanged)
        tableName.addSubview(refreshControl)
    }
    
    func makePullToRefreshEndRefreshing() {
        refreshControl.endRefreshing()
    }
}


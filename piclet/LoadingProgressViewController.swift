//
//  LoadingProgressViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 06/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class LoadingProgressViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRoundedBorder()
    }
    
    override func viewWillAppear(animated: Bool) {
        activityIndicator.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        activityIndicator.stopAnimating()
    }
    
    func createRoundedBorder() {
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = true;
    }
    
}

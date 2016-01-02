//
//  ProfileImageViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 30/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(named: "userProfileRoundPlacholder")
    }

}

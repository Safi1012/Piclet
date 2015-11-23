//
//  PostsMascotViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 23/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

protocol PostsMascotDelegate {
    
    func didPressedMascot(viewController: UIViewController)
    
}

class PostsMascotViewController: UIViewController {
    
    var challengeID: String!
    var delegate: PostsMascotDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressedMascot(sender: UIButton) {
        delegate?.didPressedMascot(self)
    }
}

//
//  ImageUploadViewController.swift
//  piclet
//
//  Created by Filipe Santos Correa on 08/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ImageUploadViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: CreateTextField!
    var pickedImage: UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedUploadNavBarItem(sender: UIBarButtonItem) {
        if let title = titleTextField.text {
            uploadPost(title)
        } else {
            displayAlert("NoTitle")
        }
    }
    
    
    // MARK: - Upload
    
    func uploadPost(title: String) {
        
        print("works")
        
    }

}
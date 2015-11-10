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
    var token: String!
    var challengeID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - UI
    
    @IBAction func pressedUploadNavBarItem(sender: UIBarButtonItem) {
        
        if validateTextField() {

            if let newImage = ImageHandler().covertImageForUpload(pickedImage) {
                print("KB: \(newImage.length / 1024)")
                uploadPost("pickedImage", image: newImage)
                
            }
        }
    }
    
    func validateTextField() -> Bool {
        guard
            let challengeName = titleTextField.text
        else {
            self.displayAlert("ChallengeNameEmpty")
            return false
        }
        if challengeName.characters.count == 0 {
            self.displayAlert("ChallengeNameEmpty")
            return false
        }
        if UserDataValidator().challengeNameContainsOnlyBlankCharacters(challengeName) {
            self.displayAlert("ChallengeNameOnlyBlankCharacters")
            return false
        }
        return true
    }
    
    
    // MARK: - Upload
    
    func uploadPost(title: String, image: NSData) {
        
        ApiProxy().addPostToChallenge(token, challengeID: challengeID, images: [image], success: { () -> () in

            print("success")
            
        }) { (errorCode) -> () in
            
            self.displayAlert(errorCode)
            
        }
    }
}



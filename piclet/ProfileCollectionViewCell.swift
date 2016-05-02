//
//  ProfileCollectionViewCell.swift
//  piclet
//
//  Created by Filipe Santos Correa on 09/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var newImage: UIImageView!
}


extension UICollectionReusableView {
    
    func addActivityIndicatorView() {
        let activityIndicator = ActivityIndicatorView(image: UIImage(named: "blueSpinner")!)
            activityIndicator.bounds =  CGRectMake(0.0, 0.0, 35.0, 35.0)
            activityIndicator.center.x = self.center.x
            activityIndicator.center.y = CGRectGetMidY(self.bounds) / 2
        
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func startAnimatingIndicatorView() {
        (self.subviews[0] as? ActivityIndicatorView)?.startAnimating()
    }

    func stopAnimatingIndicatorView() {
        (self.subviews[0] as? ActivityIndicatorView)?.stopAnimating()

        // add UIViewExtension -> access it with: view.super.xxxx()
    }
}


//
//  ProfileViewControllerDelegate.swift
//  piclet
//
//  Created by Filipe Santos Correa on 10/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation

protocol ProfileViewControllerDelegate {
    
    func userDataWasRefreshed(profileViewController: ProfileViewController, userAccount: UserAccount)
}
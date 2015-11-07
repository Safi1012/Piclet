//
//  PostsTableViewDelegate.swift
//  piclet
//
//  Created by Filipe Santos Correa on 06/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

protocol PostsTableViewDelegate {
    
    func likeButtonInCellWasPressed(cell: PostsTableViewCell, post: Post)
    
}
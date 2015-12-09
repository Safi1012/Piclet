//
//  Post.swift
//  piclet
//
//  Created by Filipe Santos Correa on 12/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class Post {
    
    var id: String!
    var description: String?
    var creator: String!
    var posted: NSDate!
    var challengeId: String!
    var votes: Int!
    var voters: [String]!
    
}
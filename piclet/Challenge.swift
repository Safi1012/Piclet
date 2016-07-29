//
//  Challenges.swift
//  piclet
//
//  Created by Filipe Santos Correa on 12/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

/// Contains all informations of a challenge
class Challenge {
    
    var id: String!
    var title: String!
    var creator: String!
    var posted: NSDate!
    var votes: Int!
    var amountPosts: Int!
    var archived: Bool!

    var creatorPost: String?
    var description: String?
    var posts: [Post]?
}



//
//  UserAccount.swift
//  piclet
//
//  Created by Filipe Santos Correa on 08/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class UserAccount {
    
    var username: String!
    var created: NSDate!
    var totalVotes: Int!
    var totalPosts: Int!
    var rank: Int!

    // allChallenges created by the user
    // var myChallenges: [Challenge]?
    
    // allPosts created by the user
    // var myPosts: [Posts]?
}


//username	string	The nickname of the user
//created	number	The unix-timestamp in milliseconds when the user got created
//totalVotes	number	Upvotes of all images of the user combined
//totalPosts	number	Amount of posted images
//rank	number	Global rank of the user
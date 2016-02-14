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
    var totalChallenges :Int!
    var rank: Int!
    var token: String!

    // allChallenges created by the user
    // var myChallenges: [Challenge]?
    
    // allPosts created by the user
    // var myPosts: [Posts]?
    
    func createUserToken(json: AnyObject, username: String) {
        guard
            let dict = json as? NSDictionary,
            let token = dict["token"] as? String
        else {
            print("createUserToken: couldn't serialize data")
            return
        }
        User.updateUserDatabase(managedObjectContext, username: username, token: token)
    }
}

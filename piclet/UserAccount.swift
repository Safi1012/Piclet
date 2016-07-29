//
//  UserAccount.swift
//  piclet
//
//  Created by Filipe Santos Correa on 08/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

/// Contains all information of an user account
class UserAccount {
    
    var username: String!
    var created: NSDate!
    var totalVotes: Int!
    var totalPosts: Int!
    var totalChallenges :Int!
    var totalLikedPosts: Int!
    var totalWonChallenges: Int!
    var rank: Int!
    var token: String!
    
    /**
     Extracts the token from a valid json formated object and saves it to the user table in the realm database
     
     - parameter json:     json formated data (the servers response)
     - parameter username: the users unique username
     */
    func createUserToken(json: AnyObject, username: String) {
        guard
            let dict = json as? NSDictionary,
            let token = dict["token"] as? String
        else {
            print("createUserToken: couldn't serialize data")
            return
        }
        UserAccess.sharedInstance.deleteAllUsers()
        UserAccess.sharedInstance.addUser(username, token: token)
    }
    
    /**
     Extracts the token from a valid json formated object and saves it to the user table in the realm database
     
     - parameter json: json formated data (the servers response)
     */
    func createUserToken(json: AnyObject) {
        guard
            let dict = json as? NSDictionary,
            let username = dict["username"] as? String,
            let token = dict["token"] as? String
        else {
            print("createUserToken: couldn't serialize data")
            return
        }
        UserAccess.sharedInstance.deleteAllUsers()
        UserAccess.sharedInstance.addUser(username, token: token)
    }
}
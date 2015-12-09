//
//  ObjectMapper.swift
//  piclet
//
//  Created by Filipe Santos Correa on 27/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ObjectMapper {
    
    func createUserToken(jsonData: NSData, username: String) {
        guard
            let jsonDict = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers),
            let dict = jsonDict as? NSDictionary,
            let token = dict["token"] as? String
            else {
                print("createUserToken: couldn't serialize data")
                return
        }
        User.updateUserDatabase(AppDelegate().managedObjectContext, username: username, token: token)
    }
    
    func parseChallenges(json: AnyObject) -> [Challenge] {
        var challenges = [Challenge]()
        
        guard
            let objects = json as? [NSDictionary]
        else {
            return challenges
        }
        
        for element in objects {
            let challenge = Challenge()
            guard
                let id = element.valueForKey("_id") as? String,
                let title = element.valueForKey("title") as? String,
                let creator = element.valueForKey("creator") as? String,
                let posted = element.valueForKey("posted") as? Int,
                let votes = element.valueForKey("votes") as? Int,
                let amountPosts = element.valueForKey("amountPosts") as? Int
            else {
                break
            }
            challenge.id = id
            challenge.title = title
            challenge.creator = creator
            challenge.posted = TimeHandler().convertTimestampToNSDate(posted)
            challenge.votes = votes
            challenge.amountPosts = amountPosts
            challenge.creatorPost = element.valueForKey("creatorPost") as? String
            challenge.description = element.valueForKey("description") as? String
            
            challenges.append(challenge)
        }
        return challenges
    }
    
    func parsePosts(json: AnyObject) -> [Post] {
        var posts = [Post]()
        
        guard
            let objects = json as? NSDictionary,
            let allPosts = objects.valueForKey("posts") as? NSArray
        else {
            print("parsePostsError")
            return posts
        }
        
        for element in allPosts {
            let post = Post()
            guard
                let id = element.valueForKey("_id") as? String,
                let creator = element.valueForKey("creator") as? String,
                let posted = element.valueForKey("posted") as? Int,
                let challengeId = element.valueForKey("challenge") as? String,
                let votes = element.valueForKey("votes") as? Int,
                let voters = element.valueForKey("voters") as? [String]
            else {
                break
            }
            post.id = id
            post.creator = creator
            post.posted = TimeHandler().convertTimestampToNSDate(posted)
            post.challengeId = challengeId
            post.votes = votes
            post.voters = voters
            post.description = element.valueForKey("description") as? String
            
            posts.append(post)
        }
        return posts
    }
    
    func parseUserAccountInformations(json: AnyObject) -> UserAccount {
        guard
            let dict = json as? NSDictionary,
            let username = dict["username"] as? String,
            let created = dict["created"] as? Int,
            let totalVotes = dict["totalVotes"] as? Int,
            let totalPosts = dict["totalPosts"] as? Int,
            let rank = dict["rank"] as? Int,
            let token = User.getLoggedInUserToken(AppDelegate().managedObjectContext)
        
        else {
            print("parseUserAccountInformationsError")
            return UserAccount()
        }
        
        let userAccount = UserAccount()
        userAccount.username = username
        userAccount.created = TimeHandler().convertTimestampToNSDate(created)
        userAccount.totalVotes = totalVotes
        userAccount.totalPosts = totalPosts
        userAccount.rank = rank
        userAccount.token = token
        
        return userAccount
    }
}





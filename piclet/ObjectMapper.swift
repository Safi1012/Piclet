//
//  ObjectMapper.swift
//  piclet
//
//  Created by Filipe Santos Correa on 27/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ObjectMapper {
    
    let managedObjectContext = AppDelegate().managedObjectContext

    func createUserToken(jsonData: NSData, username: String) {
        guard
            let jsonDict = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers),
            let dict = jsonDict as? NSDictionary,
            let token = dict["token"] as? String
        else {
            print("createUserToken: couldn't serialize data")
            return
        }
        
        User.updateUserDatabase(managedObjectContext, username: username, token: token)
    }
    
    
    func parseError(responseData: NSData) -> String {
        
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let objects = json as? NSDictionary,
            let code = objects["code"] as? String,
            let message = objects["message"] as? String
        else {
            print("parseError: couldn't serialize data")
            return "erroneousJSON"
        }
        print("\(code): \(message)")
        return code
    }
    
    
    func getChallenges(responseData: NSData) -> [Challenge] {
        
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let objects = json as? NSArray
        else {
            print("getChallenges: couldn't serialize data")
            return []
        }
    
        var challenges = [Challenge]()

        for element in objects {
        
            if let item = element as? NSDictionary {
                let challenge = Challenge()
                
                guard
                    let id = item.valueForKey("_id") as? String,
                    let title = item.valueForKey("title") as? String,
                    let creator = item.valueForKey("creator") as? String,
                    let posted = item.valueForKey("posted") as? Int,
                    let votes = item.valueForKey("votes") as? Int,
                    let amountPosts = item.valueForKey("amountPosts") as? Int
                else {
                    break
                }
                challenge.id = id
                challenge.title = title
                challenge.creator = creator
                challenge.posted = TimeHandler().convertTimestampToNSDate(posted)
                challenge.votes = votes
                challenge.amountPosts = amountPosts
                challenge.creatorPost = item.valueForKey("creatorPost") as? String
                challenge.description = item.valueForKey("description") as? String
                
                challenges.append(challenge)
            }
        }
        return challenges
    }
    
    func saveImagePost(responseData: NSData, postID: String, imageSize: ImageSize) {
        saveImage(responseData, imageName: postID, imageSize: imageSize)
    }
    
    func saveImageAvatar(responseData: NSData, username: String, imageSize: ImageSize) {
        saveImage(responseData, imageName: username, imageSize: imageSize)
    }
    
    private func saveImage(responseData: NSData, imageName: String, imageSize: ImageSize) {
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        let imagePath = documentPath.stringByAppendingPathComponent(imageName + "_" + imageSize.rawValue + ".webp")
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(imagePath, contents: responseData, attributes: nil)
    }
    
    
    func getPosts(responseData: NSData) -> [Post] {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let objects = json as? NSDictionary
        else {
            print("getPosts: couldn't serialize data")
            return []
        }
        
        var posts = [Post]()
        
        if let allPosts = objects.valueForKey("posts") as? NSArray {
            
            for element in allPosts {
                
                let post = Post()
                
                guard
                    let id = element.valueForKey("_id") as? String,
                    let creator = element.valueForKey("creator") as? String,
                    let posted = element.valueForKey("posted") as? Int,
                    let votes = element.valueForKey("votes") as? Int,
                    let voters = element.valueForKey("voters") as? [String]
                else {
                    break
                }
                post.id = id
                post.creator = creator
                post.posted = TimeHandler().convertTimestampToNSDate(posted)
                post.votes = votes
                post.voters = voters
                post.description = element.valueForKey("description") as? String
                
                posts.append(post)
            }
        }
        return posts
    }
    
    func getChallenge(responseData: NSData) -> Challenge {
        
        let challenge = Challenge()
        
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let objects = json as? NSDictionary,
            let title = objects["title"] as? String
        else {
            print("getChallenge: couldn't serialize data")
            return challenge
        }
        challenge.title = title
        return challenge
    }
    
    // test this!
    
    func getUserAccountInformation(responseData: NSData) -> UserAccount {
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let dict = json as? NSDictionary,
            
            let username = dict["username"] as? String,
            let created = dict["created"] as? Int,
            let totalVotes = dict["totalVotes"] as? Int,
            let totalPosts = dict["totalPosts"] as? Int,
            let rank = dict["rank"] as? Int
        else {
            print("getPosts: couldn't serialize data")
            return UserAccount()
        }
        
        let userAccount = UserAccount()
        userAccount.username = username
        userAccount.created = TimeHandler().convertTimestampToNSDate(created)
        userAccount.totalVotes = totalVotes
        userAccount.totalPosts = totalPosts
        userAccount.rank = rank
        
        return userAccount
    }
    
}





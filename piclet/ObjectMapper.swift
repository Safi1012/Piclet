//
//  ObjectMapper.swift
//  piclet
//
//  Created by Filipe Santos Correa on 27/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ObjectMapper: NSObject {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    
    func createUserToken(jsonData: NSData, username: String) {

        guard
            let jsonDict = try? NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers),
            let dict = jsonDict as? NSDictionary,
            let token = dict["token"] as? String
        else {
            print("createUserToken: could serialize data")
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
            print("couldn't serialize data")
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
                    let votes = item.valueForKey("votes") as? Int
                else {
                    break
                }
                
                challenge.id = id
                challenge.title = title
                challenge.creator = creator
                challenge.posted = TimeHandler().convertTimestampToNSDate(posted)
                challenge.votes = votes
                challenge.creatorPost = item.valueForKey("creatorPost") as? String
                challenge.description = item.valueForKey("description") as? String
                
                challenges.append(challenge)
            }
        }
        return challenges
    }
    
    
    func getPostImage(responseData: NSData, postID: String, imageSize: ImageSize) {
        let documentPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as NSString
        let imagePath = documentPath.stringByAppendingPathComponent(postID + "_" + imageSize.rawValue + ".webp")
        let fileManager = NSFileManager.defaultManager()
        fileManager.createFileAtPath(imagePath, contents: responseData, attributes: nil)
    }
    
    
    func getPosts(responseData: NSData) -> [Post] {
        
        guard
            let json = try? NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers),
            let objects = json as? NSArray
        else {
            print("couldn't serialize data")
            return []
        }
        
        
        var posts = [Post]()
        
        for element in objects {
            
            if let item = element as? NSDictionary {
                let post = Post()
                
                guard
                    let id = item.valueForKey("_id") as? String,
                    let creator = item.valueForKey("creator") as? String,
                    let posted = item.valueForKey("posted") as? Int,
                    let votes = item.valueForKey("votes") as? Int,
                    let voters = item.valueForKey("voters") as? [String]
                else {
                    break
                }
                
                post.id = id
                post.creator = creator
                post.posted = TimeHandler().convertTimestampToNSDate(posted)
                post.votes = votes
                post.voters = voters
                post.description = item.valueForKey("description") as? String
                
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
            return challenge
        }
        challenge.title = title
        return challenge
    }
}





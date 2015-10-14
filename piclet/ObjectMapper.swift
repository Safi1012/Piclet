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
    
    // var challenges = [Challenge]()

    func createUserToken(jsonData: NSData, username: String) {
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            User.updateUserDatabase(managedObjectContext, username: username, token: jsonDict["token"] as! String)
        } catch {
            print("createUserToken: could serialize data")
        }
    }
    
    func parseError(responseData: NSData) -> String {
        do {
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            
            let code = jsonDict["code"] as! String
            let message = jsonDict["message"] as! String

            print("\(code): \(message)")
            
            return code
        } catch {
            print("could serialize data")
        }
        return ""
    }
    
    func getChallenges(responseData: NSData) -> [Challenge] {
        do {
            print("Respone: \(String(data: responseData, encoding: NSUTF8StringEncoding))")
            
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSArray
            var challenges = [Challenge]()
            
            for element in jsonDict {
                let challenge = Challenge()

                challenge.id = (element as! NSDictionary).valueForKey("_id") as? String
                challenge.title = (element as! NSDictionary).valueForKey("title") as? String
                challenge.description = (element as! NSDictionary).valueForKey("description") as? String
                challenge.creator = (element as! NSDictionary).valueForKey("creator") as? String
                challenge.posted = (element as! NSDictionary).valueForKey("posted") as? String
                challenge.votes = (element as! NSDictionary).valueForKey("votes") as? String
                challenge.creatorPost = (element as! NSDictionary).valueForKey("creatorPost") as? String
                
                
                
                // test this!
                let post = Post()
                post.id = challenge.creatorPost
                challenge.posts = [post]
                
                
                
                challenges.append(challenge)
            }
            return challenges
        } catch {
            print("could serialize data")
        }
        return []
    }
    
    func getPostImage(responseData: NSData, postID: String, imageFormat: ImageFormat) -> Post {
        
        var image: UIImage?
        
        if imageFormat.rawValue == "jpeg" {
            image = UIImage(data: responseData)
        } else {
            // webp
        }
        
        print("Size: \(image!.size)")
        
        
        return Post()
    }
     
    
}
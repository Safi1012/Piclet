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
    
    func getChallenges(responseData: NSData) {
        do {
            
            print("Respone: \(String(data: responseData, encoding: NSUTF8StringEncoding))")
            
            let jsonDict = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSArray // [Dictionary<String, String
            
            var challengeIDs = [String]()
            var titles = [String]()
            var description = [String]()
            var creator = [String]()
            var posted = [String]()
            var totalVotels = [String]()
            var creatorID = [String]()
            
            var posts = [[]]

            for element in jsonDict {
                challengeIDs.append((element as! NSDictionary).valueForKey("_id") as! String)
                titles.append((element as! NSDictionary).valueForKey("title") as! String)
                description.append((element as! NSDictionary).valueForKey("description") as! String)
                creator.append((element as! NSDictionary).valueForKey("creator") as! String)
                posted.append((element as! NSDictionary).valueForKey("posted") as! String)
                totalVotels.append((element as! NSDictionary).valueForKey("votes") as! String)
                creatorID.append((element as! NSDictionary).valueForKey("creatorPost") as! String)
                posts.append((element as! NSDictionary).valueForKey("posts") as! NSArray)
            }
            
            
            
            
            
            print("\(challengeIDs[0])")
            print("\(titles[0])")
            

            
        } catch {
            print("ccc")
        }
    }
    
    //            for dict in jsonDict {
    //
    //
    //
    //            }
    //
    //
    //
    //            for var element (key, value) in jsonDict {
    //
    //            }
    
    
    //            for (key, value) in jsonDict {
    //                switch (element.key as! String) {
    //
    //                case "_id":
    //                    challengeID.append(value as! String)
    //                case "title":
    //                    title.append(value as! String)
    //                default:
    //                    break
    //
    //                }
    
    
    
    //                switch (key as! String) {
    //
    //                case "_id":
    //                        challengeID.append(value as! String)
    //                case "title":
    //                        title.append(value as! String)
    //                default:
    //                    break
    //                }


//            print("Challenges: \(challengeID)")
//            print("Ttitles: \(title)")
        
        
        
    
    

    
    
    
}
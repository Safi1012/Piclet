//
//  ApiProxy.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class ApiProxy {
    
    var deviceToken = ""
    
    
    // MARK: - User Account
    
    func createUserAccount(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter, deviceToken: deviceToken)
        
        NetworkHandler().requestJSON(parameter, apiPath: "users", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func createUserWithThirdPartyService(username: String, oauthToken: String, tokenType: TokenType, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["username" : (username), "oauthtoken" :  (oauthToken), "tokentype": (tokenType.rawValue), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter, deviceToken: deviceToken)
        
        NetworkHandler().requestJSON(parameter, apiPath: "users", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func signInUser(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter, deviceToken: deviceToken)
        
        NetworkHandler().requestJSON(parameter, apiPath: "tokens", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func signInUserWithThirdPartyService(oauthtoken: String, tokenType: TokenType, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["oauthtoken" : (oauthtoken), "tokentype": (tokenType.rawValue), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter, deviceToken: deviceToken)
        
        NetworkHandler().requestJSON(parameter, apiPath: "tokens", httpVerb: HTTPVerb.post, token: nil, success: { (json) in
            UserAccount().createUserToken(json)
            success()
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }
    
    func deleteThisUserToken(token: String, success: () -> (), failure: (errorCode: String) -> ()) {
        NetworkHandler().requestJSON([:], apiPath: "tokens/this", httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
        
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
        }
    }
    
    func changePassword(token: String, username: String, oldPassword: String, newPassword: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["oldPassword" : (oldPassword), "newPassword": (newPassword), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter, deviceToken: deviceToken)
        
        NetworkHandler().requestJSON(parameter, apiPath: "users/\(username)", httpVerb: HTTPVerb.put, token: token, success: { (json) in
            success()
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }
    
    
    // MARK: - Challenges
    
    func fetchChallenges(offset: Int, orderby: SegmentedControlState, archived: Bool, success: (challenges: [Challenge]) -> (), failure: (errorCode: String) -> ()) {
        let orderbyString = orderby.rawValue == SegmentedControlState.hot.rawValue ? "hot" : "new"
        let apiPath = "challenges?offset=\(offset)&orderby=\(orderbyString)&archived=\(archived)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            success(challenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func fetchWonChallenges(offset: Int, username: String, success: (challenges: [Challenge]) -> (), failure: (errorCode: String) -> ()) {
        let apiPath = "users/\(username)/wonChallenges?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: .get, token: nil, success: { (json) in
            success(challenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }
    
    
    func createNewChallenge(token: String, challengeName: String, success: () -> (), failure: (errorCode: String) -> () ){
        
        NetworkHandler().requestJSON(["title" : (challengeName)], apiPath: "challenges", httpVerb: HTTPVerb.post, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func fetchAspectRatios(challengeId: String, success: (aspectRatios: NSDictionary) -> (), failure: (errorCode: String) -> ()){
        
        NetworkHandler().requestJSON([:], apiPath: "challenges/\(challengeId)/aspectRatios", httpVerb: .get, token: nil, success: { (json) in
            success(aspectRatios: ObjectMapper().parseAspectRatios(json))
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }

    
    // MARK: - Posts
    
    func fetchChallengePosts(challengeID: String, success: (posts: [Post]) -> (), failure: (errorCode: String) -> ()) {
        
        NetworkHandler().requestJSON([:], apiPath: "challenges/\(challengeID)", httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            success(posts: ObjectMapper().parsePosts(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
                
        }
    }
    
    func addPostToChallenge(token: String, challengeID: String, image: NSData, description: String, success: () -> (), failure: (errorCode: String) -> ()) {
        
        let apiPath = "challenges/" + "\(challengeID)" + "/posts"
        
        NetworkHandler().uploadImage(["description": (description)], apiPath: apiPath, httpVerb: HTTPVerb.post, token: token, image: image, success: { (json) -> () in
            success()
            
            }) { (errorCode) -> () in
                failure(errorCode: errorCode)
                
        }
    }
    
    func likePost(token: String, challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
        
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.post, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func revertLikePost(token: String, challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
     
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        let body = ["challenge-id" : (challengeID), "post-id" : (postID)]
        
        NetworkHandler().requestJSON(body, apiPath: apiPath, httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func deleteUserPost(token: String, challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
        
        let apiPath = "challenges/\(challengeID)/posts/\(postID)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    

    // MARK: - User profile
    
    func uploadUserProfileImage(token: String, username: String, image: NSData, success: () -> (), failure: (errorCode: String) -> ()) {
    
        let apiPath = "users/\(username)/avatar"
        
        NetworkHandler().uploadImage(["nick": (username)], apiPath: apiPath, httpVerb: HTTPVerb.put, token: token, image: image, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
                
        }
    }
    
    func fetchUserAccountInformation(success: (userAccount: UserAccount) -> (), failure: (errorCode: String) -> () ) {
        
        if let user = UserAccess.sharedInstance.getUser() {
            let apiPath = "users/" + user.username
    
            NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
                success(userAccount: ObjectMapper().parseUserAccountInformations(json))
    
            }) { (errorCode) -> () in
                failure(errorCode: errorCode)
                
            }
        }
        failure(errorCode: "NotLoggedIn")
    }
    
    func fetchUserCreatedPosts(username: String, offset: Int, success: (userPosts: [PostInformation]) -> (), failure: (errorCode: String) -> () ) {
        
        let apiPath = "users/\(username)/posts?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            success(userPosts: ObjectMapper().parsePostIds(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func fetchUserCreatedChallenges(username: String, offset: Int, success: (userChallenges: [Challenge]) -> (), failure: (errorCode: String) -> () ) {
        
        let apiPath = "users/\(username)/challenges?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            success(userChallenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func fetchLikedPosts(offset: Int, success: (userPosts: [PostInformation]) -> (), failure: (errorCode: String) -> () ) {
        
        if let user = UserAccess.sharedInstance.getUser() {
            let apiPath = "users/\(user.username)/likedPosts?offset=\(offset)"
    
            NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
                success(userPosts: ObjectMapper().parsePostIds(json))
    
            }) { (errorCode) -> () in
                failure(errorCode: errorCode)
                    
            }
        } else {
            failure(errorCode: "NotLoggedIn")
        }
    }
    
    
    // MARK: - Rank
    
    func fetchRanks(offset: Int, success: (ranks: [UserRank]) -> (), failure: (errorCode: String) -> () ) {
        
        let apiPath = "users?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            success(ranks: ObjectMapper().parseRanks(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
}

enum ImageSize: String {
    case small = "small"
    case medium = "medium"
    case large = "large"
}

enum ImageFormat: String {
    case jpeg = "jpeg"
    case webp = "webp"
}

enum ChallengeOrder: String {
    case hot = "hot"
    case new = "new"
}

enum TokenType: String {
    case facebook = "facebook"
    case google   = "google"
}

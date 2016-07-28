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

/// This class helps to access the server.
class ApiProxy {
    
    var deviceToken = ""
    
    // MARK: - User Account
    
    /**
     Creates a user account if the parameters are valid
     
     - parameter username: the users unique username
     - parameter password: the users password
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func createUserAccount(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter)
        
        NetworkHandler().requestJSON(parameter, apiPath: "users", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Generates a token which is needed to verify the identity when communicating with the server
     
     - parameter username: the users unique username
     - parameter password: the users password
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func signInUser(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter)
        
        NetworkHandler().requestJSON(parameter, apiPath: "tokens", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Tells the server to delete the user token. Should be called when changing the users password
     
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func deleteThisUserToken(success: () -> (), failure: (errorCode: String) -> ()) {
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: "tokens/this", httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
        
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
        }
    }
    
    /**
     Changes the users password
     
     - parameter username:    the users unique username
     - parameter oldPassword: the users current password
     - parameter newPassword: the new user password
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func changePassword(username: String, oldPassword: String, newPassword: String, success: () -> (), failure: (errorCode: String) -> ()) {
        var parameter = ["oldPassword" : (oldPassword), "newPassword": (newPassword), "os" : "ios"]
        NetworkHandler().appendDeviceTokenIdToParameters(&parameter)
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON(parameter, apiPath: "users/\(username)", httpVerb: HTTPVerb.put, token: token, success: { (json) in
            success()
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }
    
    
    // MARK: - Challenges
    
    /**
     Fetches all challenges which matches the filter options in the parameters
     
     - parameter offset:   omit the first offset challenges. Use this for pagination (defaults to 0)
     - parameter orderby:  hot for sort by best or new for sort by new (defaults to new) challenges
     - parameter archived: whether to show only archived (=true) or only not archived (=false) challenges
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchChallenges(offset: Int, orderby: SegmentedControlState, archived: Bool, success: (challenges: [Challenge]) -> (), failure: (errorCode: String) -> ()) {
        let orderbyString = orderby.rawValue == SegmentedControlState.hot.rawValue ? "hot" : "new"
        let apiPath = "challenges?offset=\(offset)&orderby=\(orderbyString)&archived=\(archived)"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
            success(challenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Fetches all won challenges by a user
     
     - parameter offset:   omit the first offset challenges. Use this for pagination (defaults to 0)
     - parameter username: the users unique username
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchWonChallenges(offset: Int, username: String, success: (challenges: [Challenge]) -> (), failure: (errorCode: String) -> ()) {
        let apiPath = "users/\(username)/wonChallenges?offset=\(offset)"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: .get, token: token, success: { (json) in
            success(challenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Creates a new challenges
     
     - parameter challengeName: the challenge name
     - parameter success:       success callback if the request was successful
     - parameter failure:       failure callback if the request was not successful
     */
    func createNewChallenge(challengeName: String, success: () -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON(["title" : (challengeName)], apiPath: "challenges", httpVerb: HTTPVerb.post, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Fetch all aspect ratios of a chosen challenge
     
     - parameter challengeId:   the unique challenge id
     - parameter success:       success callback if the request was successful
     - parameter failure:       failure callback if the request was not successful     
     */
    func fetchAspectRatios(challengeId: String, success: (aspectRatios: NSDictionary) -> (), failure: (errorCode: String) -> ()) {
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: "challenges/\(challengeId)/aspectRatios", httpVerb: .get, token: token, success: { (json) in
            success(aspectRatios: ObjectMapper().parseAspectRatios(json))
            
        }) { (errorCode) in
            failure(errorCode: errorCode)
            
        }
    }

    
    // MARK: - Posts
    
    /**
     Fetch all posts of a challenge
     
     - parameter challengeID:   the unique challenge id
     - parameter success:       success callback if the request was successful
     - parameter failure:       failure callback if the request was not successful
     */
    func fetchChallengePosts(challengeID: String, success: (posts: [Post]) -> (), failure: (errorCode: String) -> ()) {
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: "challenges/\(challengeID)", httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
            success(posts: ObjectMapper().parsePosts(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
                
        }
    }
    
    /**
     Uploads an image to a chosen challenge
     
     - parameter challengeID: the unique challenge id
     - parameter image:       the image which should be uploaded
     - parameter description: the post description
     - parameter success:     success callback if the request was successful
     - parameter failure:     failure callback if the request was not successful
     */
    func addPostToChallenge(challengeID: String, image: NSData, description: String, success: () -> (), failure: (errorCode: String) -> ()) {
        let apiPath = "challenges/" + "\(challengeID)" + "/posts"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().uploadImage(["description": (description)], apiPath: apiPath, httpVerb: HTTPVerb.post, token: token, image: image, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
                
        }
    }
    
    /**
     Like a chosen post in a challenge
     
     - parameter challengeID: the unique challenge id
     - parameter postID:      the unique post id
     - parameter success:     success callback if the request was successful
     - parameter failure:     failure callback if the request was not successful
     */
    func likePost(challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.post, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Revert a like to a chosen post in a challenge
     
     - parameter challengeID: the unique challenge id
     - parameter postID:      the unique post id
     - parameter success:     success callback if the request was successful
     - parameter failure:     failure callback if the request was not successful
     */
    func revertLikePost(challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        let body = ["challenge-id" : (challengeID), "post-id" : (postID)]
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON(body, apiPath: apiPath, httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Deletes a user post in a challenge
     
     - parameter challengeID: the unique challenge id
     - parameter postID:      the unique post id
     - parameter success:     success callback if the request was successful
     - parameter failure:     failure callback if the request was not successful
     */
    func deleteUserPost(challengeID: String, postID: String, success: () -> (), failure: (errorCode: String) -> () ) {
        let apiPath = "challenges/\(challengeID)/posts/\(postID)"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    

    // MARK: - User profile
    
    /**
     Upload a user profile image
     
     - parameter username: the users unique username
     - parameter image:    the users profile image
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func uploadUserProfileImage(username: String, image: NSData, success: () -> (), failure: (errorCode: String) -> ()) {
        let apiPath = "users/\(username)/avatar"
        let token = UserAccess.sharedInstance.getUser()!.token
        
        NetworkHandler().uploadImage(["nick": (username)], apiPath: apiPath, httpVerb: HTTPVerb.put, token: token, image: image, success: { (json) -> () in
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
                
        }
    }
    
    /**
     Fetches the users account information
     
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchUserAccountInformation(success: (userAccount: UserAccount) -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        
        if let user = UserAccess.sharedInstance.getUser() {
            let apiPath = "users/" + user.username
    
            NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
                success(userAccount: ObjectMapper().parseUserAccountInformations(json))
    
            }) { (errorCode) -> () in
                failure(errorCode: errorCode)
                
            }
        }
        failure(errorCode: "NotLoggedIn")
    }
    
    /**
     Fetches all posts which have been created by an user
     
     - parameter username: the users unique username
     - parameter offset:   omit the first offset posts. Use this for pagination (defaults to 0)
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchUserCreatedPosts(username: String, offset: Int, success: (userPosts: [PostInformation]) -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        let apiPath = "users/\(username)/posts?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
            success(userPosts: ObjectMapper().parsePostIds(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Fetches all challenges which are created by an user
     
     - parameter username: the users unique username
     - parameter offset:   omit the first offset challenges. Use this for pagination (defaults to 0)
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchUserCreatedChallenges(username: String, offset: Int, success: (userChallenges: [Challenge]) -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        let apiPath = "users/\(username)/challenges?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
            success(userChallenges: ObjectMapper().parseChallenges(json))
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    /**
     Fetches all liked posts by an user
     
     - parameter offset:  omit the first offset posts. Use this for pagination (defaults to 0)
     - parameter success: success callback if the request was successful
     - parameter failure: failure callback if the request was not successful
     */
    func fetchLikedPosts(offset: Int, success: (userPosts: [PostInformation]) -> (), failure: (errorCode: String) -> () ) {
        
        if let user = UserAccess.sharedInstance.getUser() {
            let apiPath = "users/\(user.username)/likedPosts?offset=\(offset)"
            let token = UserAccess.sharedInstance.getUser()!.token
    
            NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
                success(userPosts: ObjectMapper().parsePostIds(json))
    
            }) { (errorCode) -> () in
                failure(errorCode: errorCode)
                    
            }
        } else {
            failure(errorCode: "NotLoggedIn")
        }
    }
    
    /**
     Fetches all received posts of an user
     
     - parameter username: the users unique username
     - parameter offset:   omit the first offset posts. Use this for pagination (defaults to 0)
     - parameter success:  success callback if the request was successful
     - parameter failure:  failure callback if the request was not successful
     */
    func fetchReceivedLikesPosts(username: String, offset: Int, success: (userPosts: [PostInformation]) -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        let apiPath = "users/\(username)/posts?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
            
            let allPosts = ObjectMapper().parsePostIds(json)
            var filteredPosts = [PostInformation]()
            
            for post in allPosts {
                if post.votes > 0 {
                    filteredPosts.append(post)
                }
            }
            success(userPosts: filteredPosts)
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    
    
    // MARK: - Rank
    
    /**
     Fetches the ranking of all users
     
     - parameter offset:  omit the first offset ranks. Use this for pagination (defaults to 0)
     - parameter success: success callback if the request was successful
     - parameter failure: failure callback if the request was not successful
     */
    func fetchRanks(offset: Int, success: (ranks: [UserRank]) -> (), failure: (errorCode: String) -> () ) {
        let token = UserAccess.sharedInstance.getUser()!.token
        let apiPath = "users?offset=\(offset)"
        
        NetworkHandler().requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: token, success: { (json) -> () in
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

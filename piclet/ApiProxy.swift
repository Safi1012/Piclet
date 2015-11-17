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
    
    var networkHandler: NetworkHandler!
    var objectMapper: ObjectMapper!
    
    init() {
        networkHandler = NetworkHandler()
        objectMapper = ObjectMapper()
    }
    

    // UserAccount
    
    func createUserAccount(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        let parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
    
        networkHandler.requestJSON(parameter, apiPath: "users", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func signInUser(username: String, password: String, success: () -> (), failure: (errorCode: String) -> ()) {
        let parameter = ["username" : (username), "password" :  (password), "os" : "ios"]
        
        networkHandler.requestJSON(parameter, apiPath: "tokens", httpVerb: HTTPVerb.post, token: nil, success: { (json) -> () in
            UserAccount().createUserToken(json, username: username)
            success()
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
    }
    
    func deleteThisUserToken(token: String, success: () -> (), failure: (errorCode: String) -> ()) {
     
        networkHandler.requestJSON([:], apiPath: "tokens/this", httpVerb: HTTPVerb.delete, token: token, success: { (json) -> () in
            success()
        
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
        }
    }
    
    
    // Challenges
    
    func getChallengesSorted(offset: Int, orderby: SegmentedControlState, success: (challenges: [Challenge]) -> (), failure: (errorCode: String) -> ()) {
        
        let orderbyString = orderby.rawValue == SegmentedControlState.hot.rawValue ? "hot" : "new"
        let apiPath = "challenges?offset=\(offset)" + "&orderby=\(orderbyString)"
        
        networkHandler.requestJSON([:], apiPath: apiPath, httpVerb: HTTPVerb.get, token: nil, success: { (json) -> () in
            //
            
        }) { (errorCode) -> () in
            failure(errorCode: errorCode)
            
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    // update to new network calls
    

    
    func getChallenges(offset: Int, orderby: SegmentedControlState, success: (challenges: [Challenge]) -> (), failed: (errorCode: String) -> ()) {
        

        
        let orderbyString = orderby.rawValue == SegmentedControlState.hot.rawValue ? "hot" : "new"
        let apiPath = "challenges?offset=\(offset)" + "&orderby=\(orderbyString)"
        
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            success(challenges: self.objectMapper.getChallenges(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    
    
    
    func getPostImageInSize(challengeID: String, postID: String, imageSize: ImageSize, imageFormat: ImageFormat, success: () -> (), failed: (errorCode: String) -> () ) {
    
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/image-\(imageSize).\(imageFormat)"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            self.objectMapper.saveImagePost(validResponseData, postID: postID, imageSize: imageSize)
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func getChallengesPosts(challengeID: String, success: (posts: [Post]) -> (), failed: (errorCode: String) -> ()) {
        
        networkHandler.createRequest([:], apiPath: ("challenges/" + challengeID), httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            success(posts: self.objectMapper.getPosts(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func likeChallengePost(token: String, challengeID: String, postID: String, success: () -> (), failed: (errorCode: String) -> () ) {
        
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "POST", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func revertLikeChallengePost(token: String, challengeID: String, postID: String, success: () -> (), failed: (errorCode: String) -> () ) {
        
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        let body = ["challenge-id" : (challengeID), "post-id" : (postID)]
        
        networkHandler.createRequest(body, apiPath: apiPath, httpVerb: "DELETE", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func postNewChallenge(token: String, challengeName: String, success: (challenge: Challenge) -> (), failed: (errorCode: String) -> () ){
        
        networkHandler.createRequest(["title" : (challengeName)], apiPath: "challenges", httpVerb: "POST", bearerToken: token, validRequest: { (validResponseData) -> () in
            success(challenge: self.objectMapper.getChallenge(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    // test this! -- Multipart - request
    func addPostToChallenge(token: String, challengeID: String, images: [NSData], description: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        let apiPath = "challenges/" + "\(challengeID)" + "/posts"
        
        networkHandler.createMultipartRequest(["description": (description)], images: images, apiPath: apiPath, httpVerb: "POST", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    
    
    
    
    
    
    
    // TEST -> use for change password
    
    func deleteAllUserAccessTokens(token: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        networkHandler.createRequest([:], apiPath: "tokens", httpVerb: "DELETE", bearerToken: token, validRequest: { (validResponseData) -> () in
            success() // dont forget to log the user out!
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
        }
    }
    
    
    
    // TEST -> use for userProfil, ask Johannes -> This call should require a jwt token!
    
    func getUserAccountInformation(username: String, success: (userAccount: UserAccount) -> (), failed: (errorCode: String) -> () ) {
        
        // GET /users/<nick>
        let apiPath = "users/" + username
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            success(userAccount: self.objectMapper.getUserAccountInformation(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    // TEST -> use for userProfil
    
    func getUserCreatedChallenges(username: String, success: (userChallenges: [Challenge]) -> (), failed: (errorCode: String) -> () ) {
        
        // GET /users/<nick>/challenges
        let apiPath = "users/" + username + "/challenges'"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            success(userChallenges: self.objectMapper.getChallenges(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    // TEST -> use for userProfil
    
    func getUserCreatedPosts(username: String, success: (userPosts: [Post]) -> (), failed: (errorCode: String) -> () ) {
        
        // GET /users/<nick>/posts
        let apiPath = "users/" + username + "/posts"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            success(userPosts: self.objectMapper.getPosts(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    // TEST - Avatar user Image
    
    func getUserAvatar(username: String, imageSize: ImageSize, imageFormat: ImageFormat, success: () -> (), failed: (errorCode: String) -> () ) {
        //GET /users/<nick>/avatar-<size>.<format>
        let apiPath = "users/" + username + "/avatar-" + imageSize.rawValue + "." + imageFormat.rawValue
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: nil, validRequest: { (validResponseData) -> () in
            self.objectMapper.saveImageAvatar(validResponseData, username: username, imageSize: imageSize)
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    
    // TEST!
    
    func changeUserPassword(username: String, oldPassword: String, newPassword: String, token: String, success: () -> (), failed: (errorCode: String) -> () ) {
        // PUT /users/<nick>
        
        let apiPath = "users/" + username
        let requestBody = ["oldPassword" : (oldPassword), "newPassword" : (newPassword), "os" : "ios"]
        
        networkHandler.createRequest(requestBody, apiPath: apiPath, httpVerb: "PUT", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }

    
    // TEST - changes avatar image,  The request-body is the binary data of the image as jpeg-image
    
    func changeUserAvatar(token: String, username: String, newAvatarImage: UIImage, success: () -> (), failed: (errorCode: String) -> () ) {
        // PUT /users/<nick>/avatar
        let apiPath = "users/" + username + "/avatar"
        let avatarData = UIImageJPEGRepresentation(newAvatarImage, CGFloat(0.7))!
        let requestBody = ["avatar" : (avatarData)]
        
        
        // check documentation for request body:   ""avatar" : (request)
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "PUT", bearerToken: token, validRequest: { (validResponseData) -> () in
            // parse 
            // success
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
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

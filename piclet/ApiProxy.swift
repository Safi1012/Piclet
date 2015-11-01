//
//  ApiProxy.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ApiProxy {
    
    var networkHandler: NetworkHandler!
    var objectMapper: ObjectMapper!
    
    init() {
        networkHandler = NetworkHandler()
        objectMapper = ObjectMapper()
    }

    func handleUser(username: String, password: String, apiPath: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        let body = ["username" : (username), "password" :  (password), "os" : "ios"]
        
        networkHandler.createRequest(body, apiPath: apiPath, httpVerb: "POST", bearerToken: nil, validRequest: { (validResponseData) -> () in
            self.objectMapper.createUserToken(validResponseData, username: username)
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func deleteToken(token: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        networkHandler.createRequest([:], apiPath: "tokens", httpVerb: "DELETE", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func getChallenges(token: String?, offset: Int, orderby: SegmentedControlState, success: (challenges: [Challenge]) -> (), failed: (errorCode: String) -> ()) {
        
        let orderbyString = orderby.rawValue == SegmentedControlState.hot.rawValue ? "hot" : "new"
        let apiPath = "challenges?offset=\(offset)" + "&orderby=\(orderbyString)"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: token, validRequest: { (validResponseData) -> () in
            success(challenges: self.objectMapper.getChallenges(validResponseData))
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func getPostImageInSize(token: String?, challengeID: String, postID: String, imageSize: ImageSize, imageFormat: ImageFormat, success: () -> (), failed: (errorCode: String) -> () ) {
    
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/image-\(imageSize).\(imageFormat)"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: token, validRequest: { (validResponseData) -> () in
            self.objectMapper.getPostImage(validResponseData, postID: postID, imageSize: imageSize)
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
    
    func likeChallengePost(token: String?, challengeID: String, postID: String, success: () -> (), failed: (errorCode: String) -> () ) {
        
        let apiPath = "challenges/\(challengeID)/posts/\(postID)/like"
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "POST", bearerToken: token, validRequest: { (validResponseData) -> () in
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            failed(errorCode: self.objectMapper.parseError(invalidResponseData))
            
        }) { (errorCode) -> () in
            failed(errorCode: errorCode)
            
        }
    }
    
    func revertLikeChallengePost(token: String?, challengeID: String, postID: String, success: () -> (), failed: (errorCode: String) -> () ) {
        
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
    
    func postNewChallenge(token: String?, challengeName: String, success: (challenge: Challenge) -> (), failed: (errorCode: String) -> () ){
        
        networkHandler.createRequest(["title" : (challengeName)], apiPath: "challenges", httpVerb: "POST", bearerToken: token, validRequest: { (validResponseData) -> () in
            success(challenge: self.objectMapper.getChallenge(validResponseData))
            
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

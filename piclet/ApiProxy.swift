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

            self.objectMapper.createUserToken(validResponseData!, username: username)
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in

            invalidResponseData != nil ? failed(errorCode: self.objectMapper.parseError(invalidResponseData!)) : failed(errorCode: "")
            
        }) { (errorCode) -> () in
            
            failed(errorCode: errorCode)
        }
    }
    
    func deleteToken(token: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        networkHandler.createRequest([:], apiPath: "tokens", httpVerb: "DELETE", bearerToken: token, validRequest: { (validResponseData) -> () in
            
            success()
            
        }, inValidRequest: { (invalidResponseData) -> () in
            
            invalidResponseData != nil ? failed(errorCode: self.objectMapper.parseError(invalidResponseData!)) : failed(errorCode: "")
            
        }) { (errorCode) -> () in
            
            failed(errorCode: errorCode)
        }
    }
    
    
    func getChallenges(token: String?, offset: String, success: () -> (), failed: (errorCode: String) -> ()) {
        
        let apiPath = "challenges?offset=" + offset
        print("API: \(apiPath)")
        
        networkHandler.createRequest([:], apiPath: apiPath, httpVerb: "GET", bearerToken: token, validRequest: { (validResponseData) -> () in
            
            // parse Data
            
            self.objectMapper.getChallenges(validResponseData!)
            success()
            
            
        }, inValidRequest: { (invalidResponseData) -> () in
            
            invalidResponseData != nil ? failed(errorCode: self.objectMapper.parseError(invalidResponseData!)) : failed(errorCode: "")
            
            
        }) { (errorCode) -> () in
            
            failed(errorCode: errorCode)
            
        }
        
        
    }
    

    
    
    
    
    
    
}



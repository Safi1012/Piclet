//
//  NetworkHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class NetworkHandler: NSObject {
    
    func createRequest(apiParameters: Dictionary<String, String>, apiPath: String,
        httpVerb: String, bearerToken: String?, validRequest: (validResponseData: NSData) -> (), inValidRequest: (invalidResponseData: NSData) -> (), networkError: (errorCode: String) -> ()) {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://flash1293.de/" + apiPath)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 5.0)
            request.HTTPMethod = httpVerb
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            if bearerToken != nil {
                request.addValue("Bearer \(bearerToken!)", forHTTPHeaderField: "Authorization")
            }
            if httpVerb != "GET" {
                do {
                    request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(apiParameters, options: NSJSONWritingOptions.PrettyPrinted)
                } catch {
                    print("Couldn't convert JSON to Objects: \(error) \n")
                }
            }
            
        let newTask = NSURLSession.sharedSession().dataTaskWithRequest(request) { (responseData, response, error) -> Void in
            
            if error != nil {
                print("NetworkError: \(error)")
                networkError(errorCode: "NetworkError")
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    
                    if let responseData = responseData {
                        switch (httpResponse.statusCode) {
                            
                        case 200...299:
                            validRequest(validResponseData: responseData)
                        case 400...599:
                            inValidRequest(invalidResponseData: responseData)
                        default:
                            break
                        }
                    } else {
                        networkError(errorCode: "")
                    }
                }
            }
        }
        newTask.resume()
    }
}





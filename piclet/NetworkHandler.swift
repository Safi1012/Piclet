//
//  NetworkHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

/// Handles all network requests
class NetworkHandler: NSObject {
    
    /**
     Creates an asyncronous request
     
     - parameter apiParameters: the HTTP-Body information
     - parameter apiPath:       the servers api path where the requested information lies
     - parameter httpVerb:      the HTTP Verb: GET, POST, PUT or DELETE
     - parameter token:         this param is optional. This token is used to verify the users identity to the server
     - parameter success:       success callback with a json formated object, if the request was successful
     - parameter failure:       failure callback with an errorCode, if the request was not successful
     */
    func requestJSON(apiParameters: [String: String], apiPath: String, httpVerb: HTTPVerb, token: String?, success: (json: AnyObject) -> (), failure: (errorCode: String) -> () ) {
        
        if let serverAddress = ServerAccess.sharedInstance.getServer()?.serverAddress {
            let headers = generateHeaders(token)
            let httpVerb = Alamofire.Method(rawValue: httpVerb.rawValue)!
            let encoding = apiParameters.count > 0 ? ParameterEncoding.JSON : ParameterEncoding.URL
        
            Alamofire.request(httpVerb, "\(serverAddress)/\(apiPath)", parameters: apiParameters, encoding: encoding, headers: headers)
                .responseJSON { response in
                    
                    switch response.result {
                        
                    case .Success:
                        switch (response.response?.statusCode)! {
                            
                        case 200...299:
                            success(json: response.result.value!)
                            
                        default:
                            failure(errorCode: ErrorHandler().getErrorCode(response.result.value!))
                        }
                        
                    case .Failure:
                        failure(errorCode: "NetworkError")
                    }
            }
            
        } else {
            failure(errorCode: "NetworkError")
            
        }
    }
    
    /**
     Creates an ayncronous HTTP-Request to upload an image to the server
     
     - parameter apiParameters: the HTTP-Body information
     - parameter apiPath:       the servers api path where the requested information lies
     - parameter httpVerb:      the HTTP Verb: GET, POST, PUT or DELETE
     - parameter token:         this param is optional. This token is used to verify the users identity to the server
     - parameter image:         the image data
     - parameter success:       success callback with a json formated object, if the request was successful
     - parameter failure:       failure callback with an errorCode, if the request was not successful
     */
    func uploadImage(apiParameters: Dictionary<String, String>, apiPath: String, httpVerb: HTTPVerb, token: String?, image: NSData,
        success: (json: AnyObject) -> (), failure: (errorCode: String) -> () ) {
        
        if let serverAddress = ServerAccess.sharedInstance.getServer()?.serverAddress {
            let headers = generateHeaders(token)
            let json = try! NSJSONSerialization.dataWithJSONObject(apiParameters, options: NSJSONWritingOptions.PrettyPrinted)
            let verb = Alamofire.Method(rawValue: httpVerb.rawValue)!
            
            Alamofire.upload (
                verb,
                "\(serverAddress)/\(apiPath)",
                headers: headers,
                multipartFormData: { multipartFormData in
                    multipartFormData.appendBodyPart(
                        data: json,
                        name: "header"
                    )
                    multipartFormData.appendBodyPart(
                        data: image,
                        name: "file",
                        fileName: "file.jpeg",
                        mimeType: "image/jpeg"
                    )
                },
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                        
                    case .Success(let upload, _, _):
                        upload.responseJSON { response in
                            
                            switch (response.response?.statusCode)! {
                                
                            case 200...299:
                                success(json: response.result.value!)
                                
                            default:
                                failure(errorCode: ErrorHandler().getErrorCode(response.result.value!))
                            }
                        }
                        
                    case .Failure:
                        failure(errorCode: "NetworkError")
                    }
                }
            )
        } else {
            failure(errorCode: "NetworkError")
            
        }
    }
    
    /**
     Generates an HTTP-Header
     
     - parameter token: this param is optional. This token is used to verify the users identity to the server
     
     - returns: if the token was not empty the return the header uses Bearer as the autorization, if not it uses a Basic autorization as the header information
     */
    func generateHeaders(token: String?) -> [String: String] {
        if token != nil {
            return ["Authorization": "Bearer \(token!)"]
        } else {
            let auth = "server:\(ServerAccess.sharedInstance.getServer()!.serverPassword)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
            return ["Authorization": "Basic \(auth)"]
        }
    }
}

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}






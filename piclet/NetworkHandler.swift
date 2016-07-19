//
//  NetworkHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import Alamofire

class NetworkHandler: NSObject {
    
    func requestJSON(apiParameters: [String: String], apiPath: String, httpVerb: HTTPVerb, token: String?, success: (json: AnyObject) -> (), failure: (errorCode: String) -> () ) {
        
        let headers = generateHeaders(token)
        let httpVerb = Alamofire.Method(rawValue: httpVerb.rawValue)!
        let encoding = apiParameters.count > 0 ? ParameterEncoding.JSON : ParameterEncoding.URL
        
        if let serverAddress = ServerAccess.sharedInstance.getServer()?.serverAddress {
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
            
            
        }
    }
    
    func uploadImage(apiParameters: Dictionary<String, String>, apiPath: String, httpVerb: HTTPVerb, token: String?, image: NSData,
        success: (json: AnyObject) -> (), failure: (errorCode: String) -> () ) {
        
        let headers = generateHeaders(token)
        let json = try! NSJSONSerialization.dataWithJSONObject(apiParameters, options: NSJSONWritingOptions.PrettyPrinted)
        let verb = Alamofire.Method(rawValue: httpVerb.rawValue)!
        let serverAddress = ServerAccess.sharedInstance.getServer()?.serverAddress
        
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
    }
    
    func generateHeaders(token: String?) -> [String: String] {
        if token != nil {
            return ["Authorization": "Bearer \(token!)"]
        } else {
            let auth = "server:\(ServerAccess.sharedInstance.getServer()!.serverPassword)".dataUsingEncoding(NSUTF8StringEncoding)!.base64EncodedStringWithOptions([])
            return ["Authorization": "Basic \(auth)"]
        }
    }
    
    func appendDeviceTokenIdToParameters(inout parameters: [String : String]) {
        let deviceToken = (UIApplication.sharedApplication().delegate as! AppDelegate).deviceToken
        
        if deviceToken.characters.count > 0 {
            parameters.updateValue((deviceToken), forKey: "deviceId")
        }
    }
        
}

enum HTTPVerb: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}






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
    
    
    
    // MULTIPART
    
    func createMultipartRequest(parameters: Dictionary<String, String>, images: [NSData], apiPath: String, httpVerb: String, bearerToken: String?,
        validRequest: (validResponseData: NSData) -> (),
        inValidRequest: (invalidResponseData: NSData) -> (),
        networkError: (errorCode: String) -> ())
    {
        let boundary = generateBoundaryString()
        
        let urlRequest = createMultipartHeader(apiPath, httpVerb: httpVerb, boundary: boundary, bearerToken: bearerToken)
            urlRequest.HTTPBody = createMultipartBody(boundary, parameters: parameters, images: images, filePathKey: "file")
        
        
        
        let newTask = NSURLSession.sharedSession().dataTaskWithRequest(urlRequest) { (responseData, response, error) -> Void in
            
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
    
    
    private func createMultipartHeader(apiPath: String, httpVerb: String, boundary: String, bearerToken: String?) -> NSMutableURLRequest {
        
        let request = NSMutableURLRequest(URL: NSURL(string: "https://flash1293.de/" + apiPath)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 5.0)
            request.HTTPMethod = httpVerb
            request.addValue("application/json", forHTTPHeaderField: "multipart/form-data; boundary=\(boundary)")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if bearerToken != nil {
            request.addValue("Bearer \(bearerToken!)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    

    private func createMultipartBody(boundary: String, parameters: Dictionary<String, String>?, images: [NSData]?, filePathKey: String?) -> NSData {
        
        let body = NSMutableData()

        if parameters != nil {
            for (key, value) in parameters! {
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        if images != nil && filePathKey != nil {
            for image in images! {

                let mimetype = mimeTypeForImageData(image)
                
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"image.jpeg\"\r\n")
                body.appendString("Content-Type: \(mimetype)\r\n\r\n")
                body.appendData(image)
                body.appendString("\r\n")
            }
        }
        body.appendString("--\(boundary)--\r\n")
        return body
    }
    
    private func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }

    private func mimeTypeForImageData(imageData: NSData) -> String {
        
        var c = [UInt32](count: 1, repeatedValue: 0)
        
        imageData.getBytes(&c, length: 1)
        
        switch (c[0]) {
            
        case 0xFF:
            return "image/jpeg"
        
        case 0x89:
            return "image/png"
            
        case 0x47:
            return "image/gif"
            
        case 0x49, 0x4D:
            return "image/tiff"
            
        default:
            return "application/octet-stream"
        }
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}





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
            urlRequest.HTTPBody = createMultipartBody(boundary, parameters: parameters, images: images, filePathKey: "userfile")
        
        
        
        
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
            request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if bearerToken != nil {
            request.addValue("Bearer \(bearerToken!)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
    

    private func createMultipartBody(boundary: String, parameters: [String: String]?, images: [NSData]?, filePathKey: String?) -> NSData {
        
        let body = NSMutableData()
        

        
        // paramaters
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(parameters!, options: NSJSONWritingOptions.PrettyPrinted)
            
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"something\"")
            body.appendString("\r\n\r\n")
            body.appendData(data);
        } catch {
            print("Couldn't convert JSON to Objects: \(error) \n")
        }
        
        
        let data = try! NSJSONSerialization.dataWithJSONObject(parameters!, options: NSJSONWritingOptions.PrettyPrinted)
        
        let mimetype = mimeTypeForImageData(images![0])
        
        body.appendString("\r\n--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"abc\"; filename=\"image.jpeg\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(images![0])
        body.appendString("\r\n--\(boundary)--")
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





//
//  JWTParser.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/04/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation

class JWTParser {
    
    func suggestUsernameFromJWT(jwtToken: String) -> String {
        let token = removeSignature(jwtToken)
        let base64String = appendEqualSignToMatchBase64Specification(token)
        let email = extractEmailAddress(decodeBase64Data(base64String))
        
        return extractUsernameFromEmail(email)
    }
    
    func decodeBase64Data(token: String) -> String {
        if let decodedData = NSData(base64EncodedString: token, options: .IgnoreUnknownCharacters) {
            return NSString(data: decodedData, encoding: NSUTF8StringEncoding) as! String
        }
        return ""
    }
    
    func removeSignature(jwtToken: String) -> String {
        var token = jwtToken
        
        let firstRange = token.rangeOfString(".")!
        token = token.substringFromIndex(firstRange.startIndex.successor())
        
        let secondRange = token.rangeOfString(".")!
        token = token.substringToIndex(secondRange.startIndex)
        
        return token
    }
    
    func extractEmailAddress(decodedBase64String: String) -> String {
        guard
            let jsonDict = try? NSJSONSerialization.JSONObjectWithData(decodedBase64String.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions.MutableContainers),
            let dict = jsonDict as? NSDictionary,
            let email = dict["email"] as? String
        else {
            print("couldn't serialize data: JWTParser")
            return ""
        }
        return email
    }
    
    func extractUsernameFromEmail(email: String) -> String {
        if let range = email.rangeOfString("@") {
            return email.substringToIndex(range.startIndex)
        }
        return ""
    }
    
    // Base64String must end with an equal sign
    // The string's length must be a multiple of four to be valid! -> if not fill the remaing characters with equal signs
    func appendEqualSignToMatchBase64Specification(token: String) -> String {
        var base64String = token

        repeat {
            base64String += "="
        } while base64String.characters.count % 4 != 0
        
        print(base64String)
        
        return base64String
    }
    
    
}
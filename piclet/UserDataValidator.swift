//
//  UserDataValidator.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class UserDataValidator {
    
    /**
     Checks whether the username is at least 3 characters long
     
     - parameter userName: the unique users username
     
     - returns: true if the username is longer than 3 characters, else false
     */
    func isUsernameLongEnough(userName: String) -> Bool {
        if (userName.characters.count >= 3) {
            return true
        }
        return false
    }
    
    /**
     Checks whether the password is at least 3 characters long
     
     - parameter password: the users password
     
     - returns: true if the password is longer than 3 characters, else false
     */
    func isPasswordLongEnough(password: String) -> Bool {
        if (password.characters.count >= 3) {
            return true
        }
        return false
    }
    
    /**
     Checks if the users unique username has any non alphanumerical characters
     
     - parameter userName: the users unique username
     
     - returns: true if the username doesnt contain any non alphanumerical characters, else false
     */
    func containsSpecialCharacters(userName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [.CaseInsensitive])
        
        if (regex.firstMatchInString(userName, options: [], range: NSMakeRange(0, userName.utf16.count)) != nil) {
            return true
        }
        return false
    }
    
    /**
     Checks if the challenge name consists of only blank characters
     
     - parameter challengeName: the challenge name
     
     - returns: true if the challenge doesnt consist of only blank characters, else false
     */
    func challengeNameContainsOnlyBlankCharacters(challengeName: String) -> Bool {
        let stringWithoutBlanks = challengeName.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if stringWithoutBlanks.characters.count > 0 {
            return false
        }
        return true
    }
    
    /**
     Checks if both password are identical
     
     - parameter firstPassword:  the current user password
     - parameter secondPassword: the new user password
     
     - returns: true if both passwords match, else false
     */
    func isPasswordEqual(firstPassword: String, secondPassword: String) -> Bool {
        return firstPassword == secondPassword ? true : false
    }

}
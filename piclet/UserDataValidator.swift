//
//  UserDataValidator.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/09/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class UserDataValidator {
    
    func isUsernameLongEnough(userName: String) -> Bool {
        if (userName.characters.count >= 4) {
            return true
        }
        return false
    }
    
    func isPasswordLongEnough(userName: String) -> Bool {
        if (userName.characters.count >= 8) {
            return true
        }
        return false
    }
    
    func containsSpecialCharacters(userName: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: [.CaseInsensitive])
        
        if (regex.firstMatchInString(userName, options: [], range: NSMakeRange(0, userName.utf16.count)) != nil) {
            return true
        }
        return false
    }
    
    func challengeNameContainsOnlyBlankCharacters(challengeName: String) -> Bool {
        let stringWithoutBlanks = challengeName.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        if stringWithoutBlanks.characters.count > 0 {
            return false
        }
        return true
    }

}
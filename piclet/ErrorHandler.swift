//
//  ErrorHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 13/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ErrorHandler {
    
    func getErrorCode(json: AnyObject) -> String {
        guard
            let jsonDict = json as? NSDictionary,
            let errorCode = jsonDict["code"] as? String,
            let errorMessage = jsonDict["message"] as? String
        else {
            print("InvalidJSON")
            return "InvalidJSON"
        }
        print("ErrorCode: \(errorCode), Message: \(errorMessage)")
        return errorCode
    }
    
    func getTitleAndMessageError(errorCode: String) -> (title: String, message: String) {
        
        switch(errorCode) {
            
        case "UsernameTakenError":
            return ("Username is already taken", "The username you chose is already taken. Please try a different one, Thanks!")
            
        case "UsernameNotFoundError":
            return ("Incorrect Username", "Could not find the username you typed. Please try it again.")
            
        case "WrongPasswordError":
            return ("Incorrect Password", "The password you typed is wrong. Please try it again.")
            
        case "UsernameTooShort":
            return ("Username is invalid", "The Username must be at least 4 characters long.")
            
        case "UsernameWrongCharacters":
            return ("Username is invalid", "The Username may not contain any special characters.")
            
        case "PasswordTooShort":
            return ("Password is invalid", "The password must be at least 4 characters long.")
            
        case "LogoutError":
            return ("Logout failed", "Could not logout from the app. Are you connected to the internet?")
            
        case "NotLoggedIn":
            return ("Not logged in", "You are not logged in. Create a free account or login with your existing one.")
            
        case "UnauthorizedError":
            return ("Invalid Session", NSLocalizedString("NO_INTERNET_ALERT", comment: ""))
            
        case "NoPictureError":
            return ("No Picture", "You must choose a picture to create a post. You can choose from your image gallery or take a new shoot.")
            
        case "NoTitle":
            return ("No Title", "To upload a Post, you must add a title. Just type a title that describes your post.")
            
        case "ChallengeNameEmpty":
            return ("Challenge name is empty", "To create a Challenge, you need to type a challenge name.")
            
        case "ChallengeNameOnlyBlankCharacters":
            return ("Invalid Title", "You only typed blank spaces. Please enter a title that describes your challenge best.")
            
        case "AlreadyPostedError":
            return ("Already Posted", "You already posted in this challenge. Please choose a different Challenge.")
            
        case "PasswordNewTooShort":
            return ("Password is too short", "Your new password must be at least 4 characters long.")
            
        default:
            return ("", "")
        }
    }
}
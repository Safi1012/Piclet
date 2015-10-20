//
//  ErrorHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 13/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ErrorHandler {
    
    func getTitleAndMessageError(errorCode: String) -> (title: String, message: String) {
        
        switch(errorCode) {
            
        case "NetworkError":
            return ("No internet", NSLocalizedString("NO_INTERNET_ALERT", comment: ""))
            
        case "UsernameTakenError":
            return ("Username is already taken", "The username you chose is already taken. Please try a different one. Thanks!")
            
        case "UsernameNotFound":
            return ("Username not found", "The username or password you typed does not exists. Please try it again.")
            
        case "WrongPassword":
            return ("Wrong Password", "The password you typed is wrong. Please try it again.")
            
        case "ErroneousFields":
            return ("Login not found", "Could not find the Account. The username or password you typed is wrong. Please try it again.")
            
        case "UsernameTooShort":
            return ("Username invalid", "The Username must be at least 4 characters long.")
            
        case "UsernameWrongCharacters":
            return ("Username invalid", "The Username cannot contain any special characters.")
            
        case "PasswordTooShort":
            return ("Password invalid", "The password must be at least 8 characters long.")
            
        case "LogoutError":
            return ("Logout failed", "Could not logout from the app. Are you connected to the internet?")
            
        case "AlreadyVoted":
            return ("Already Voted", "You alredy voted for this challenge.")
            
        case "NotLoggedIn":
            return ("Not logged in", "Only users that have an account, can Vote.")
            
        case "UnauthorizedError":
            return ("Invalid Session", "You Session has timed out. Please login again.")
            
        default:
            return ("Unexpected Error", "Please try again.")
        }
    }
}
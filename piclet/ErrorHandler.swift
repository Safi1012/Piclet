//
//  ErrorHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 13/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ErrorHandler {
    
    func createErrorAlert(errorCode: String) -> UIAlertController {
        switch(errorCode) {
            
        case "NetworkError":
            return createAlert("No Internet", message: "You are not connected to the internet. Please check your Network settings and try again. Thanks!")
            
        case "UsernameTakenError":
            return createAlert("Username is already taken", message: "The username you chose is already taken. Please try a different one. Thanks!")
            
        case "UsernameNotFound":
            return createAlert("Username not found", message: "The username or password you typed does not exists. Please try it again.")
            
        case "WrongPassword":
            return createAlert("Wrong Password", message: "The password you typed is wrong. Please try it again.")
            
        case "ErroneousFields":
            return createAlert("Login not found", message: "Could not find the Account. The username or password you typed is wrong. Please try it again.")
            
        case "UsernameTooShort":
            return createAlert("Username invalid", message: "The Username must be at least 4 characters long.")
            
        case "UsernameWrongCharacters":
            return createAlert("Username invalid", message: "The Username cannot contain any special characters.")
            
        case "PasswordTooShort":
            return createAlert("Password invalid", message: "The password must be at least 8 characters long.")
            
        case "LogoutError":
            return createAlert("Logout failed", message: "Could not logout from the app. Are you connected to the internet?")
            
        default:
            return createAlert("Server problem", message: "Our server is currently in maintenance. Plase try it again.")
        }
    }

    private func createAlert(title: String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
        return alertController
    }

}
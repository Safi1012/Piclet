//
//  UserAccess.swift
//  piclet
//
//  Created by Filipe Santos Correa on 10/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation
import RealmSwift

/// Allows to get the user inforamtion from the realm database
class UserAccess {
    
    static let sharedInstance = UserAccess()
    private init() {}
    
    /*!
     Adds user information to the database
     
     - parameter username: the users unique username within the app
     - parameter token:    the generated token from the server
     */
    func addUser(username: String, token: String) {
        let user = User()
            user.username = username
            user.token = token
        
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    /*!
     Returns the first object in the user table
     
     - returns: the first saved user object
     */
    func getUser() -> User? {
        return realm.objects(User).first
    }
    
    /*!
     Deletes all saved objects from the user table
     */
    func deleteAllUsers() {
        try! realm.write {
            if let user = getUser() {
                realm.delete(user)
            }
        }
    }
    
    /*!
     Checks if the user is currently signed-in. When the user infromation is found in the user table it means that the user is signed-in
     
     - returns: true if the user is signed-in, false if the user is not signed-in
     */
    func isUserLoggedIn() -> Bool {
        return realm.objects(User).count > 0 ? true : false
    }
}
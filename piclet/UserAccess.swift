//
//  UserAccess.swift
//  piclet
//
//  Created by Filipe Santos Correa on 10/03/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation
import RealmSwift

class UserAccess {
    
    static let sharedInstance = UserAccess()
    private init() {}
    
    
    func addUser(username: String, token: String) {
        let user = User()
            user.username = username
            user.token = token
        
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    
    func getUser() -> User? {
        return realm.objects(User).first
    }
    
    func deleteAllUsers() {
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return realm.objects(User).count > 0 ? true : false
    }
}
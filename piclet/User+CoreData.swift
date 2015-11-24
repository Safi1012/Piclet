//
//  User+CoreDataProperties.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {
    
    class func updateUserDatabase(moc: NSManagedObjectContext, username: String, token: String) {
        let user = findUserInDatabase(moc, username: username)
        
        if user == nil {
            addUserToDatabase(moc, username: username, token: token)
        } else  {
            updateUserToken(moc, user: user!, newToken: token)
        }
    }
    
    class func findUserInDatabase(moc: NSManagedObjectContext, username: String) -> User? {
        let fetchRequest = NSFetchRequest(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "username = %@", username)
        
        do {
            let fetchResult = try moc.executeFetchRequest(fetchRequest) as! [User]
            
            if fetchResult.count > 0 {
                return fetchResult[0]
            }
        } catch {
            print("CoreData: \(error)")
        }
        return nil
    }
    
    class func addUserToDatabase(moc: NSManagedObjectContext, username: String, token: String) {
        let user = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: moc) as! User
            user.setValue(username, forKey: "username")
            user.setValue(token, forKey: "token")
        
        do {
            try moc.save()
        } catch {
            print("CoreData: \(error)")
        }
    }

    class func updateUserToken(moc: NSManagedObjectContext, user: User, newToken: String?) {
        user.token = newToken

        do {
            try moc.save()
        } catch {
            print("CoreData could not save data: \(error)")
        }
    }
    
    class func getUserInformation(moc: NSManagedObjectContext, username: String) -> User? {
        
        let fetchRequest = NSFetchRequest(entityName: "User")
        
        do {
            let fetchResult = try moc.executeFetchRequest(fetchRequest) as! [User]
            
            if fetchResult.count > 0 {
                return fetchResult[0]
            }
        } catch {
            print("CoreData: \(error)")
        }
        return nil
    }
    
    class func getLoggedInUser(moc: NSManagedObjectContext) -> User? {
        let fetchRequest = NSFetchRequest(entityName: "User")
            fetchRequest.predicate = NSPredicate(format: "token != nil")
        
        do {
            let fetchResult = try moc.executeFetchRequest(fetchRequest) as! [User]
            
            if fetchResult.count > 0 {
                return fetchResult[0]
            }
        } catch {
            print("CoreData: \(error)")
        }
        return nil
    }
    
    
    class func removeUserToken(moc: NSManagedObjectContext) -> Bool {
        
        if let loggedInUser = getLoggedInUser(moc) {
            loggedInUser.token = nil
            
            do {
                try moc.save()
            } catch {
                print("CoreData could not save data: \(error)")
                return false
            }
            return true
        }
        return false
    }
    
}






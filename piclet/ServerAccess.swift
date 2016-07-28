//
//  ServerAccess.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/07/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation
import RealmSwift

class ServerAccess {
    
    static let sharedInstance = ServerAccess()
    private init() {}
    
    /*!
     Returns the persited server information
     
     - returns: the first saved server object
     */
    func getServer() -> Server? {
        return realm.objects(Server.self).first
    }
    
    /*!
     Adds server information to the database
     
     - parameter serverAddress:  the server address. The server must use an secured https connection
     - parameter serverPassword: the server password
     */
    func addServer(serverAddress: String, serverPassword: String) {
        if (getServer() != nil) {
            deleteServer()
        }
        
        let server = Server()
            server.serverAddress = serverAddress
            server.serverPassword = serverPassword
        
        try! realm.write {
            realm.add(server)
        }
    }

    /*!
     Deletes all saved objects from the server table
     */
    func deleteServer() {
        try! realm.write {
            if let server = getServer() {
                 realm.delete(server)
            }
        }
    }
}
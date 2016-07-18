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
    
    func getServer() -> Server? {
        return realm.objects(Server).first
    }
    
    func addServer(serverAddress: String) {
        if (getServer() != nil) {
            deleteServer()
        }
        
        let server = Server()
        server.serverAddress = serverAddress
        
        try! realm.write {
            realm.add(server, update: true)
        }
    }

    func deleteServer() {
        try! realm.write {
            realm.deleteAll()
        }
    }
}
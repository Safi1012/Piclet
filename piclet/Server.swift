//
//  Server.swift
//  piclet
//
//  Created by Filipe Santos Correa on 18/07/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation
import RealmSwift

class Server: Object {
    
    dynamic var serverAddress: String = ""
    dynamic var serverPassword = ""
    
    override static func primaryKey() -> String? {
        return "serverAddress"
    }
    
}
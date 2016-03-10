//
//  User.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    
    dynamic var username: String = ""
    dynamic var token = ""
    
    override static func primaryKey() -> String? {
        return "username"
    }
}

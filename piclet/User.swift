//
//  User.swift
//  piclet
//
//  Created by Filipe Santos Correa on 02/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import CoreData

// @objc(User)
class User: NSManagedObject {

    @NSManaged var username: String?
    @NSManaged var token: String?

}

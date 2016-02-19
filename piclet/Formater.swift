//
//  Formater.swift
//  piclet
//
//  Created by Filipe Santos Correa on 19/02/16.
//  Copyright © 2016 Filipe Santos Correa. All rights reserved.
//

import Foundation

class Formater {
    
    func formatSingularAndPlural(number: Int, singularWord: String) -> String {
        if number == 1 {
            return "\(number) \(singularWord)"
        }
        return "\(number) \(singularWord)s"
    }
    
}
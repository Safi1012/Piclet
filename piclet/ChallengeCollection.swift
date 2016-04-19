//
//  ChallengeCollection.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation
import UIKit

class ChallengeCollection {
    
    init(section: SegmentedControlState) {
        self.section = section
    }
    
    var section: SegmentedControlState
    
    var challenge: [Challenge] {
        get {
            switch section {
                
            case .hot:
                return hotChallenges
            
            case .new:
                return newChallenges
                
            case .archived:
                return archivedChallenges
            }
        }
        set {
            switch section {
                
            case .hot:
                self.hotChallenges = newValue
                
            case .new:
                self.newChallenges = newValue
                
            case .archived:
                self.archivedChallenges = newValue
            }
        }
    }
    
    var timestamp: NSDate? {
        get {
            switch section {
                
            case .hot:
                return hotTimestamp
                
            case .new:
                return newTimestamp
                
            case .archived:
                return archivedTimestamp
            }
        }
        set {
            switch section {
                
            case .hot:
                self.hotTimestamp = newValue
                
            case .new:
                self.newTimestamp = newValue
                
            case .archived:
                self.archivedTimestamp = newValue
            }
        }
    }
    
    var offsetY: CGFloat {
        get {
            switch section {
                
            case .hot:
                return hotContentOffsetY
                
            case .new:
                return newContentOffsetY
                
            case .archived:
                return archivedContentOffsetY
            }
        }
        set {
            switch section {
                
            case .hot:
                self.hotContentOffsetY = newValue
                
            case .new:
                self.newContentOffsetY = newValue
                
            case .archived:
                self.archivedContentOffsetY = newValue
            }
        }
    }
    
    private var hotChallenges = [Challenge]()
    private var newChallenges = [Challenge]()
    private var archivedChallenges = [Challenge]()
    
    private var hotTimestamp: NSDate?
    private var newTimestamp: NSDate?
    private var archivedTimestamp: NSDate?
    
    private var hotContentOffsetY = CGFloat(0.0)
    private var newContentOffsetY = CGFloat(0.0)
    private var archivedContentOffsetY = CGFloat(0.0)
}



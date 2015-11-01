//
//  ChallengeCollection.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/11/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class ChallengeCollection {
    
    init(section: SegmentedControlState) {
        self.section = section
    }
    
    var section: SegmentedControlState
    
    var challenge: [Challenge] {
        get {
            if section == SegmentedControlState.hot {
                return hotChallenges
            }
            return newChallenges
        }
        set {
            if section == SegmentedControlState.hot {
                self.hotChallenges = newValue
            } else {
                self.newChallenges = newValue
            }
        }
    }
    
    var timestamp: NSDate? {
        get {
            if section == SegmentedControlState.hot {
                return hotTimestamp
            }
            return newTimestamp
        }
        set {
            if section == SegmentedControlState.hot {
                self.hotTimestamp = newValue
            } else {
                self.newTimestamp = newValue
            }
        }
    }
    private var hotChallenges = [Challenge]()
    private var newChallenges = [Challenge]()
    
    private var hotTimestamp: NSDate?
    private var newTimestamp: NSDate?
}
//
//  UIScreenExtension.swift
//  piclet
//
//  Created by Filipe Santos Correa on 01/12/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import UIKit

extension UIScreen {
    
    // each device with iOS 8.0 > is a Retina device
    func getDisplayInchSize() -> DeviceInchSize {
        
        let screenWidth = UIScreen.mainScreen().bounds.width
        let screenHeight = UIScreen.mainScreen().bounds.height
        let maxScreenLength = max(screenWidth, screenHeight)
        
        switch (maxScreenLength) {

        case _ where maxScreenLength < 568.0:
            return DeviceInchSize.inch_3_5
            
        case 568.0:
            return DeviceInchSize.inch_4_0
            
        case 667.0:
            return DeviceInchSize.inch_4_7
            
        case _ where maxScreenLength >= 736.0: // >= is for newer upcoming devices..
            return DeviceInchSize.inch_5_5
            
        default:
            // fallback for upcoming devices which could have different resolutions
            return DeviceInchSize.inch_4_7
        }
    }
}

enum DeviceInchSize: CGFloat {
    case inch_3_5 = 3.5
    case inch_4_0 = 4.0
    case inch_4_7 = 4.7
    case inch_5_5 = 5.5
}
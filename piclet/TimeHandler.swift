//
//  TimeHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 20/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

class TimeHandler {
    
    func getPostedTimestampFormated(datePosted: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: datePosted, toDate: NSDate(), options: [])
        
        if calendar.year > 0 {
            return "\(calendar.year)y"
        }
        if calendar.month > 0 {
            return "\(calendar.month)mth"
        }
        if calendar.weekday > 0 {
            return "\(calendar.weekday)w"
        }
        if calendar.day > 0 {
            return "\(calendar.day)d"
        }
        if calendar.hour > 0 {
            return "\(calendar.hour)h"
        }
        if calendar.minute > 0 {
            return "\(calendar.minute)m"
        }
        return "\(calendar.second)s"
    }
    
    func convertTimestampToNSDate(millisecons: Int) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(Double(millisecons / 1000)))
    }
    
}
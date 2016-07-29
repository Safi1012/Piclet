//
//  TimeHandler.swift
//  piclet
//
//  Created by Filipe Santos Correa on 20/10/15.
//  Copyright © 2015 Filipe Santos Correa. All rights reserved.
//

import Foundation

/// This class handles the time. Use this class to convert and format time
class TimeHandler {
    
    /**
     Generates the number of seconds / minutes / hours / days / weeks / months / years of a given date object
     
     - parameter datePosted: a date object
     
     - returns: a string containing the amount of seconds / minutes / hours / days / weeks / months / years
     */
    func getPostedTimestampFormated(datePosted: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar().components([.Year, .Month, .Weekday, .Day, .Hour, .Minute, .Second], fromDate: datePosted, toDate: NSDate(), options: [])
        
        if calendar.year > 0 {
            return calendar.year > 1 ? "\(calendar.year) years" : "\(calendar.year) year"
        }
        if calendar.month > 0 {
            return calendar.month > 1 ? "\(calendar.month) months" : "\(calendar.month) month"
        }
        if calendar.weekday > 0 {
            return calendar.weekday > 1 ? "\(calendar.weekday) weeks" : "\(calendar.weekday) week"
        }
        if calendar.day > 0 {
            return calendar.day > 1 ? "\(calendar.day) days" : "\(calendar.day) day"
        }
        if calendar.hour > 0 {
            return calendar.hour > 1 ? "\(calendar.hour) hours" : "\(calendar.hour) hour"
        }
        if calendar.minute > 0 {
            return calendar.minute > 1 ? "\(calendar.minute) minutes" : "\(calendar.minute) minute"
        }
        return calendar.second > 1 ? "\(calendar.second) seconds" : "\(calendar.second) second"
    }
    
    /**
     Converts an unix timestamp in milliseconds to an NSDate object
     
     - parameter millisecons: an unix timestamp in milliseconds
     
     - returns: an NSDate object
     */
    func convertTimestampToNSDate(millisecons: Int64) -> NSDate {
        return NSDate(timeIntervalSince1970: NSTimeInterval(Double(millisecons / 1000)))
    }
    
    /**
     The number of seconds passed between a given timestamp and now
     
     - parameter timestamp: an unix timestamp
     
     - returns: the number in seconds
     */
    func secondsPassedSinceDate(timestamp: NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar().components([.Second], fromDate: timestamp, toDate: NSDate(), options: [])
        return calendar.second
    }
}
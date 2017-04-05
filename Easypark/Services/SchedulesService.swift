//
//  SchedulesService.swift
//  Easypark
//
//  Created by Sebastien Bastide on 22/03/2017.
//  Copyright © 2017 Sebastien Bastide. All rights reserved.
//

import Foundation
import EasyparkModel

class SchedulesService: NSObject {
    
    public static let sharedInstance = SchedulesService()
    
    func parkingIsOpen(schedulesArray: [Schedules], parkingStatus: String) -> Bool {
        var open = false
        let currentDay = self.getCurrentDay()
        if schedulesArray.count > 1, parkingStatus == "5" {
            for schedules in schedulesArray {
                if schedules.day == currentDay {
                    open = self.isOpen(startTime: schedules.strat_time!, endTime: schedules.end_time!)
                }
            }
        }
        return open
    }
    
    private func getCurrentDay() -> String {
        let now = Date()
        let date = DateFormatter()
        date.dateStyle = .full
        date.timeStyle = .none
        date.locale = Locale(identifier: "Fr-fr")
        
        let dateString = date.string(from: now)
        guard let day = dateString.components(separatedBy: " ").first else {
            return ""
        }
        return day
    }
    
    private func isOpen(startTime: String, endTime: String) -> Bool {
        let now = Date()
        let date = DateFormatter()
        date.dateStyle = .full
        date.timeStyle = .short
        date.locale = Locale(identifier: "Fr-fr")
        
        let dateString = date.string(from: now).components(separatedBy: " ").dropLast().joined(separator: " ")
        
        let startTime = dateString + " " + startTime
        let endTime = dateString + " " + endTime
        
        let dateStartTime = self.stringToDate(date: startTime)
        let dateEndTime = self.stringToDate(date: endTime)
        
        if now.compare(dateStartTime) == .orderedDescending, now.compare(dateEndTime) == .orderedAscending {
            return true
        } else {
            return false
        }
    }
    
    private func stringToDate(date: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "Fr-fr")
        
        guard let dateObj = dateFormatter.date(from: date) else {
            print("Error parsing string to date")
            return Date()
        }
        return dateObj
    }

}

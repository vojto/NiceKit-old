//
//  NSDate+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 28/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

// Extension

public extension NSDate {
    public var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(self)
    }

    public var endOfDay: NSDate {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())!
    }
}
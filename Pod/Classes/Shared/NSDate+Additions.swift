//
//  NSDate+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 28/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

// Extension

public extension Date {
    public var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    public var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return (Calendar.current as NSCalendar).date(byAdding: components, to: startOfDay, options: NSCalendar.Options())!
    }
}

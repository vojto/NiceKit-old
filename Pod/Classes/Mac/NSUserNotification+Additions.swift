//
//  NSUserNotification.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 14/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension NSUserNotification {
    public static func deliver(_ title: String, text: String) {
        let center = NSUserNotificationCenter.default
        let notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = text
        center.deliver(notification)
    }
}

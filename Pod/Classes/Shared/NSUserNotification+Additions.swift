//
//  NSUserNotification.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 14/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension NSUserNotification {
    static func deliver(title: String, text: String) {
        let center = NSUserNotificationCenter.defaultUserNotificationCenter()
        let notification = NSUserNotification()
        
        notification.title = title
        notification.informativeText = text
        center.deliverNotification(notification)
    }
}
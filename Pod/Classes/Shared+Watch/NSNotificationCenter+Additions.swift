//
//  NSNotificationCenter+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension NotificationCenter {
    public func replace(_ notifName: String, obj: AnyObject?, newObj: AnyObject?, target: AnyObject, selector: Selector) {
        if obj != nil {
            self.removeObserver(target, name: NSNotification.Name(rawValue: notifName), object: obj)
        }
        
        if newObj != nil {
            self.addObserver(target, selector: selector, name: NSNotification.Name(rawValue: notifName), object: newObj)
        }
    }
    
    public static func post(_ notifName: String) {
        self.post(notifName, nil)
    }
    
    public static func post(_ notifName: String, _ object: AnyObject?) {
        let center = NotificationCenter.default
        let notification = Notification(name: Notification.Name(rawValue: notifName), object: object)
        center.post(notification)
    }
    
    public static func on(_ notifName: String, handler: @escaping (_ obj: AnyObject?) -> ()) {
        let center = NotificationCenter.default
        
        center.addObserver(forName: NSNotification.Name(rawValue: notifName), object: nil, queue: nil) { notification in
            let obj = notification.object
            handler(obj as AnyObject?)
        }
    }
}

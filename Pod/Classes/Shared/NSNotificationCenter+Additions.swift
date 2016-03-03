//
//  NSNotificationCenter+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension NSNotificationCenter {
    func replace(notifName: String, obj: AnyObject?, newObj: AnyObject?, target: AnyObject, selector: Selector) {
        if obj != nil {
            self.removeObserver(target, name: notifName, object: obj)
        }
        
        if newObj != nil {
            self.addObserver(target, selector: selector, name: notifName, object: newObj)
        }
    }

    static func post(notifName: String) {
        self.post(notifName, nil)
    }
    
    static func post(notifName: String, _ object: AnyObject?) {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: notifName, object: object)
        center.postNotification(notification)
    }
    
    static func on(notifName: String, handler: (obj: AnyObject?) -> ()) {
        let center = NSNotificationCenter.defaultCenter()
        
        center.addObserverForName(notifName, object: nil, queue: nil) { notification in
            let obj = notification.object
            handler(obj: obj)
        }
    }
}
//
//  NSObject+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 09/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

struct EventObservingConstants {
    static var observersKey = NSString(string: "__eventObservers__")
}

open class NKEventObserver {
    let observer: NSObjectProtocol
    
    public init(observer: NSObjectProtocol) {
        self.observer = observer
    }
    
    open func off() {
        let center = NotificationCenter.default
        center.removeObserver(self.observer)
    }
}

public extension NSObject {
    public func trigger(_ name: String) {
        self.trigger(name, data: nil)
    }
    
    public func trigger(_ name: String, data: AnyObject?) {
        let identifier = self.eventIdentifier(name)
        let center = NotificationCenter.default
        var userInfo = [String: AnyObject]()
        if let data = data {
            userInfo["data"] = data
        }
        let notification = Notification(name: Notification.Name(rawValue: identifier), object: self, userInfo: userInfo)
        center.post(notification)
    }
    
    public func on(_ name: String, handler: @escaping (_ data: AnyObject?) -> ()) -> NKEventObserver {
        let identifier = self.eventIdentifier(name)
        let center = NotificationCenter.default
        let systemObserver = center.addObserver(forName: NSNotification.Name(rawValue: identifier), object: self, queue: nil) { notification in
            if let userInfo = (notification as NSNotification).userInfo as? [String: AnyObject] {
                let data = userInfo["data"]
                handler(data)
            }
        }
        
        let observer = NKEventObserver(observer: systemObserver)
        
        return observer
    }
    
    fileprivate func eventIdentifier(_ name: String) -> String {
        return "\(Unmanaged.passUnretained(self).toOpaque())_\(name)"
    }
    
    /*
    private func recordObserver(identifier: String, observer: NSObjectProtocol) {
        Swift.print("Recording observer: \(observer)")
        
        Swift.print("All observers: \(self._eventObservers())")
        
        let observers = self._eventObservers()
        var observersForEvent = observers.objectForKey(identifier)
        
        if observersForEvent == nil {
            observersForEvent = NSMutableArray()
            observers.setObject(observersForEvent!, forKey: identifier)
        }
        
        Swift.print("Recorded observer: \(observers)")
        
        observersForEvent?.addObject(observer)
    }
    
    private func _eventObservers() -> NSMutableDictionary {
        var observers = objc_getAssociatedObject(self, &EventObservingConstants.observersKey)
        
        if observers == nil {
            Swift.print("Creating new array of observers")
            observers = NSMutableDictionary()
            objc_setAssociatedObject(self, &EventObservingConstants.observersKey, observers, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
        return observers as! NSMutableDictionary
    }
    */
}

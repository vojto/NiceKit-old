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

public class NKEventObserver {
    let observer: NSObjectProtocol
    
    public init(observer: NSObjectProtocol) {
        self.observer = observer
    }
    
    public func off() {
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self.observer)
    }
}

public extension NSObject {
    public func trigger(name: String) {
        self.trigger(name, data: nil)
    }
    
    public func trigger(name: String, data: AnyObject?) {
        let identifier = self.eventIdentifier(name)
        let center = NSNotificationCenter.defaultCenter()
        var userInfo = [String: AnyObject]()
        if let data = data {
            userInfo["data"] = data
        }
        let notification = NSNotification(name: identifier, object: self, userInfo: userInfo)
        center.postNotification(notification)
    }
    
    public func on(name: String, handler: (data: AnyObject?) -> ()) -> NKEventObserver {
        let identifier = self.eventIdentifier(name)
        let center = NSNotificationCenter.defaultCenter()
        let systemObserver = center.addObserverForName(identifier, object: self, queue: nil) { notification in
            if let userInfo = notification.userInfo as? [String: AnyObject] {
                let data = userInfo["data"]
                handler(data: data)
            }
        }
        
        let observer = NKEventObserver(observer: systemObserver)
        
        return observer
    }
    
    private func eventIdentifier(name: String) -> String {
        return "\(unsafeAddressOf(self))_\(name)"
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
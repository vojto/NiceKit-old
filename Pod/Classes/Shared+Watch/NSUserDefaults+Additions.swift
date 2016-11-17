//
//  NSUserDefaults+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension UserDefaults {
    public func set(_ value: AnyObject?, forKey key: String) {
        self.set(value, forKey: key)
    }
    
    public func get(_ key: String) -> AnyObject? {
        return self.object(forKey: key) as AnyObject?
    }
    
    public func getInt(_ key: String) -> Int? {
        return self.get(key) as? Int
    }
    
    public func getBool(_ key: String) -> Bool? {
        return self.get(key) as? Bool
    }
}

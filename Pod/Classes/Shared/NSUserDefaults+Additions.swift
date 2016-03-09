//
//  NSUserDefaults+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension NSUserDefaults {
    public static func set(value: AnyObject?, forKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
    }
    
    public static func get(key: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    public static func getInt(key: String) -> Int? {
        return self.get(key) as? Int
    }
    
    public static func getBool(key: String) -> Bool? {
        return self.get(key) as? Bool
    }
}
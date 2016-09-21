//
//  NSUserDefaults+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension UserDefaults {
    public static func set(_ value: AnyObject?, forKey key: String) {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    
    public static func get(_ key: String) -> AnyObject? {
        let defaults = UserDefaults.standard
        return defaults.object(forKey: key) as AnyObject?
    }
    
    public static func getInt(_ key: String) -> Int? {
        return self.get(key) as? Int
    }
    
    public static func getBool(_ key: String) -> Bool? {
        return self.get(key) as? Bool
    }
}

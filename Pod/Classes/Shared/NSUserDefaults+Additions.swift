//
//  NSUserDefaults+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    static func set(value: AnyObject?, forKey key: String) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
    }
    
    static func get(key: String) -> AnyObject? {
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    static func getInt(key: String) -> Int? {
        return self.get(key) as? Int
    }
    
    static func getBool(key: String) -> Bool? {
        return self.get(key) as? Bool
    }
}
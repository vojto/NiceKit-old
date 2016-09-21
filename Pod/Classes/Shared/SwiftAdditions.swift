//
//  SwiftAdditions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 29/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Array {
    func get(_ index: Int) -> Element? {
        if index >= 0 && index < count {
            return self[index]
        }

        return nil
    }
}

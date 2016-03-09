//
//  CAAnimationGroup+.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 30/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import QuartzCore

public extension CAAnimationGroup {
    public var stays: Bool {
        get {
            return !removedOnCompletion && fillMode == kCAFillModeForwards
        }
        set {
            if newValue {
                removedOnCompletion = false
                fillMode = kCAFillModeForwards
            } else {
                removedOnCompletion = true
                fillMode = kCAFillModeRemoved
            }
        }
    }
}
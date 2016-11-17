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
            return !isRemovedOnCompletion && fillMode == kCAFillModeForwards
        }
        set {
            if newValue {
                isRemovedOnCompletion = false
                fillMode = kCAFillModeForwards
            } else {
                isRemovedOnCompletion = true
                fillMode = kCAFillModeRemoved
            }
        }
    }
}

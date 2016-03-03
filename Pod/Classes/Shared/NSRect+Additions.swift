//
//  NSRect+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

func NSRectMidPoint(rect: NSRect) -> NSPoint {
    return NSMakePoint(NSMidX(rect), NSMidY(rect))
}
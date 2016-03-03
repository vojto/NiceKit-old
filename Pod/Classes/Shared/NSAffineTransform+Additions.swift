//
//  NSAffineTransform+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 14/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension NSAffineTransform {
    static func flipCoordinates(rect: NSRect) {
        let transform = NSAffineTransform()
        transform.translateXBy(0, yBy: rect.size.height)
        transform.scaleXBy(1.0, yBy: -1.0)
        transform.concat()
    }
}
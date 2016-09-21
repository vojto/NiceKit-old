//
//  NSAffineTransform+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 14/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension AffineTransform {
    static func flipCoordinates(_ rect: NSRect) {
        var transform = AffineTransform.identity
        transform.translate(x: 0, y: rect.size.height)
        transform.scale(x: 1.0, y: -1.0)
        (transform as NSAffineTransform).concat()
    }
}

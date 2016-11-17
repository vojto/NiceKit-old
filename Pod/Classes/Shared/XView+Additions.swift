//
//  NSView+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cartography


public extension XView {

    // MARK: - Shared additions
    // ------------------------------------------------------------------------

    public func getLayer() -> CALayer {
        #if os(OSX)
            wantsLayer = true
            return layer!
        #else
            return layer
        #endif
    }

    // MARK: - OSX Additions
    // ------------------------------------------------------------------------

#if os(OSX)
    public var alpha: CGFloat {
        get { return CGFloat(self.getLayer().opacity) }
        set { self.getLayer().opacity = Float(newValue) }
    }

    public static func animateWithDuration(_ duration: TimeInterval, animations: () -> Void, completion: ((Bool) -> Void)?) {
        animations()
        completion?(true)
    }

    public func layoutSubviews() {}
#endif
}




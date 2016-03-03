//
//  NSView+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cartography


extension XView {

    // MARK: - Shared additions
    // ------------------------------------------------------------------------

    func getLayer() -> CALayer {
        #if os(OSX)
            wantsLayer = true
            return layer!
        #else
            return layer
        #endif
    }


    func hide() {
        hidden = true
    }

    func show() {
        hidden = false
    }

    // MARK: - OSX Additions
    // ------------------------------------------------------------------------

#if os(OSX)
    var alpha: CGFloat {
        get { return CGFloat(self.getLayer().opacity) }
        set { self.getLayer().opacity = Float(newValue) }
    }

    static func animateWithDuration(duration: NSTimeInterval, animations: () -> Void, completion: ((Bool) -> Void)?) {
        animations()
        completion?(true)
    }

    func layoutSubviews() {}
#endif
}



extension Array where Element:XView {
    func hide() {
        for view in self {
            view.hide()
        }
    }

    func show() {
        for view in self {
            view.show()
        }
    }
}
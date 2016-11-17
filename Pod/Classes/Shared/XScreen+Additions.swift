//
//  XScreen+Additions.swift
//  FocusList
//
//  Created by Vojtech Rinik on 11/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

extension XScreen {
    #if os(OSX)
    public var scale: CGFloat {
        return self.backingScaleFactor
    }
    #endif

    public static var mainScale: CGFloat {
        #if os(OSX)
        return main()!.scale
        #else
        return mainScreen().scale
        #endif
    }
}

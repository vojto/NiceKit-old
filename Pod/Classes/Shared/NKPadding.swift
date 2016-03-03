//
//  NKPadding.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public struct NKPadding {
    var top: CGFloat = 0
    var right: CGFloat = 0
    var bottom: CGFloat = 0
    var left: CGFloat = 0

    public init(top: CGFloat, right: CGFloat, bottom: CGFloat, left: CGFloat) {
        self.top = top
        self.right = right
        self.bottom = bottom
        self.left = left
    }

    public init(vertical: CGFloat, horizontal: CGFloat) {
        top = vertical
        bottom = vertical
        right = horizontal
        left = horizontal
    }
    
    public var horizontal: CGFloat {
        get {
            return left + right
        }
    }
    
    public var vertical: CGFloat {
        get {
            return top + bottom
        }
    }
    
    public var edgeInsets: XEdgeInsets {
        get {
            return XEdgeInsetsMake(top, left, bottom, right)
        }
    }
    
//    func __conversion() -> XEdgeInsets {
//        return edgeInsets
//    }
//    
//    func __conversion() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
//        return (top, right, bottom, left)
//    }
}
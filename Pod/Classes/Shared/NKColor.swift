//
//  NKColor.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics
import SwiftColors

public class NKColor: NSObject {
    var colors: [XColor]?
    
    override public init() {
        super.init()
    }

    public init(_ hex: String) {
        let color = XColor(hexString: hex, alpha: 1)!
        self.colors = [color]

        super.init()
    }
    
    public convenience init(_ hex: String, _ alpha: Float) {
        let color = XColor(hexString: hex, alpha: alpha)!
        self.init()
        
        self.colors = [color]
    }
    


    
    public var color: XColor {
        return colors!.first!
    }

    public var CGColor: CGColorRef {
        return color.CGColor
    }
    
    public func set() {
        color.set()
    }
    
    static public func yellow() -> NKColor {
        return NKColor("fffd6e")
    }
    
    public static func white() -> NKColor {
        return NKColor("ffffff")
    }
    
    public static func orange() -> NKColor {
        return NKColor("FFCDA1")
    }
    
    public static func green() -> NKColor {
        return NKColor("9EFFDB")
    }
    
    public static func blue() -> NKColor {
        return NKColor("9ECAFF")
    }
    
    public static func black() -> NKColor {
        return NKColor("000000")
    }

    public static func red() -> NKColor {
        return NKColor("f00")
    }
}
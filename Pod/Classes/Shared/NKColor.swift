//
//  NKColor.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

open class NKColor: NSObject {
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
    


    
    open var color: XColor {
        return colors!.first!
    }

    open var CGColor: CGColor {
        return color.cgColor
    }
    
    open func set() {
        color.set()
    }
    
    static open func yellow() -> NKColor {
        return NKColor("fffd6e")
    }
    
    open static func white() -> NKColor {
        return NKColor("ffffff")
    }
    
    open static func orange() -> NKColor {
        return NKColor("FFCDA1")
    }
    
    open static func green() -> NKColor {
        return NKColor("9EFFDB")
    }
    
    open static func blue() -> NKColor {
        return NKColor("9ECAFF")
    }
    
    open static func black() -> NKColor {
        return NKColor("000000")
    }

    open static func red() -> NKColor {
        return NKColor("f00")
    }
}

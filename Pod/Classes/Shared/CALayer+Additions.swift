//
//  CALayer+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 28/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import QuartzCore

public extension CALayer {
    public func animate(_ property: String, to: CGFloat, duration: Double) {
        let currentValue = value(forKey: property)

        let animation = CABasicAnimation()
        animation.fromValue = currentValue
        animation.toValue = to
        animation.duration = duration

        add(animation, forKey: property)

        setValue(to, forKey: property)
    }

    public var scale: (CGFloat, CGFloat) {
        get {
            return (transform.m11, transform.m22)
        }
        set {
            let (x, y) = newValue
            transform = CATransform3DMakeScale(x, y, 1)
        }
    }

}


public extension CAShapeLayer {
    public static func circleLayer(_ frame: CGRect) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.frame = frame
        let path = XBezierPath(ovalIn: frame)
        layer.path = path.CGPath

        return layer
    }
}

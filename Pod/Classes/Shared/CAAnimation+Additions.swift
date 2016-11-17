//
//  CAAnimation+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 30/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import QuartzCore

func toRadians(_ degrees: Double) -> CGFloat {
    return CGFloat(degrees / 180 * M_PI)
}

func toDegrees(_ radians: Double) -> CGFloat {
    return CGFloat(radians * 180.0 / M_PI)
}

public extension CAAnimation {
    public class func rotate(_ from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let (value1, value2) = valuesForRotation(from, to: to)
        return createAnimation("transform", from: value1, to: value2, duration: duration, beginTime: beginTime)
    }

    public class func scale(_ from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let (value1, value2) = valuesForScale(from, to: to)
        return createAnimation("transform", from: value1, to: value2, duration: duration, beginTime: beginTime)
    }

    public class func opacity(_ from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("opacity", from: from as AnyObject?, to: to as AnyObject?, duration: duration, beginTime: beginTime)
    }

    public class func strokeColor(_ from: CGColor?, to: CGColor?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("strokeColor", from: from, to: to, duration: duration, beginTime: beginTime)
    }

    public class func fillColor(_ from: CGColor?, to: CGColor?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("fillColor", from: from, to: to, duration: duration, beginTime: beginTime)
    }

    fileprivate class func createAnimation(_ key: String, from: AnyObject?, to: AnyObject?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: key)
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.isRemovedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.fromValue = from
        anim.toValue = to
        anim.duration = duration
        anim.beginTime = beginTime

        return anim
    }


    fileprivate class func valuesForRotation(_ from: Double, to: Double) -> (NSValue, NSValue) {
        let trans1 = CATransform3DMakeRotation(toRadians(from), 0, 0, 1)
        let trans2 = CATransform3DMakeRotation(toRadians(to), 0, 0, 1)

        return (NSValue(caTransform3D: trans1), NSValue(caTransform3D: trans2))
    }

    fileprivate class func valuesForScale(_ from: Double, to: Double) -> (NSValue, NSValue) {
        let trans1 = CATransform3DMakeScale(CGFloat(from), CGFloat(from), 1)
        let trans2 = CATransform3DMakeScale(CGFloat(to), CGFloat(to), 1)

        return (NSValue(caTransform3D: trans1), NSValue(caTransform3D: trans2))
    }
}

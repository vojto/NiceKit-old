//
//  CAAnimation+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 30/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import QuartzCore

func toRadians(degrees: Double) -> CGFloat {
    return CGFloat(degrees / 180 * M_PI)
}

func toDegrees(radians: Double) -> CGFloat {
    return CGFloat(radians * 180.0 / M_PI)
}

extension CAAnimation {
    class func rotate(from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let (value1, value2) = valuesForRotation(from, to: to)
        return createAnimation("transform", from: value1, to: value2, duration: duration, beginTime: beginTime)
    }

    class func scale(from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let (value1, value2) = valuesForScale(from, to: to)
        return createAnimation("transform", from: value1, to: value2, duration: duration, beginTime: beginTime)
    }

    class func opacity(from: Double, to: Double, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("opacity", from: from, to: to, duration: duration, beginTime: beginTime)
    }

    class func strokeColor(from: CGColorRef?, to: CGColorRef?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("strokeColor", from: from, to: to, duration: duration, beginTime: beginTime)
    }

    class func fillColor(from: CGColorRef?, to: CGColorRef?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        return createAnimation("fillColor", from: from, to: to, duration: duration, beginTime: beginTime)
    }

    private class func createAnimation(key: String, from: AnyObject?, to: AnyObject?, duration: CFTimeInterval, beginTime: CFTimeInterval) -> CABasicAnimation {
        let anim = CABasicAnimation(keyPath: key)
//        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        anim.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeForwards
        anim.fromValue = from
        anim.toValue = to
        anim.duration = duration
        anim.beginTime = beginTime

        return anim
    }


    private class func valuesForRotation(from: Double, to: Double) -> (NSValue, NSValue) {
        let trans1 = CATransform3DMakeRotation(toRadians(from), 0, 0, 1)
        let trans2 = CATransform3DMakeRotation(toRadians(to), 0, 0, 1)

        return (NSValue(CATransform3D: trans1), NSValue(CATransform3D: trans2))
    }

    private class func valuesForScale(from: Double, to: Double) -> (NSValue, NSValue) {
        let trans1 = CATransform3DMakeScale(CGFloat(from), CGFloat(from), 1)
        let trans2 = CATransform3DMakeScale(CGFloat(to), CGFloat(to), 1)

        return (NSValue(CATransform3D: trans1), NSValue(CATransform3D: trans2))
    }
}
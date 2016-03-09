//
//  NSBezierPath+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 12/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public extension XBezierPath {
    public convenience init(pieSliceInRect rect: CGRect, size: CGFloat) {
        self.init()
        let mid = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
        let radius = rect.size.width / 2
        self.moveToPoint(mid)
        
//        addArcWithCenter(mid, radius: radius, startAngle: 90-360*size, endAngle: 90, clockwise: true)

        let start = CGFloat(0 - M_PI/2)
        let end = start + size * CGFloat(M_PI*2.0)

        addArcWithCenter(mid, radius: radius, startAngle: start, endAngle: end, clockwise: true)
        addLineToPoint(mid)
    }

    #if os(OSX)
    public convenience init(roundedRect: CGRect, cornerRadius: CGFloat) {
        self.init(roundedRect: roundedRect, xRadius: cornerRadius, yRadius: cornerRadius)
    }

    public func addCurveToPoint(point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        curveToPoint(point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    public func addLineToPoint(point: CGPoint) {
        lineToPoint(point)
    }

    public func addArcWithCenter(center: CGPoint, radius: CGFloat, var startAngle: CGFloat, var endAngle: CGFloat, clockwise: Bool) {

        startAngle = toDegrees(Double(startAngle))
        endAngle = toDegrees(Double(endAngle))


        appendBezierPathWithArcWithCenter(center, radius: radius, startAngle: startAngle, endAngle: endAngle)
    }
    #endif
}


// Taken from: https://gist.github.com/juliensagot/9749c3a1df28c38fb9f9
public extension XBezierPath {

    #if os(OSX)

    public var CGPath: CGPathRef {

        get {
            return self.transformToCGPath()
        }
    }

    /// Transforms the NSBezierPath into a CGPathRef
    ///
    /// :returns: The transformed NSBezierPath
    private func transformToCGPath() -> CGPathRef {

        // Create path
        let path = CGPathCreateMutable()
        let points = UnsafeMutablePointer<NSPoint>.alloc(3)
        let numElements = self.elementCount

        if numElements > 0 {

            var didClosePath = true

            for index in 0..<numElements {

                let pathType = self.elementAtIndex(index, associatedPoints: points)

                switch pathType {

                case .MoveToBezierPathElement:
                    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
                case .LineToBezierPathElement:
                    CGPathAddLineToPoint(path, nil, points[0].x, points[0].y)
                    didClosePath = false
                case .CurveToBezierPathElement:
                    CGPathAddCurveToPoint(path, nil, points[0].x, points[0].y, points[1].x, points[1].y, points[2].x, points[2].y)
                    didClosePath = false
                case .ClosePathBezierPathElement:
                    CGPathCloseSubpath(path)
                    didClosePath = true
                }
            }
            
            if !didClosePath { CGPathCloseSubpath(path) }
        }
        
        points.dealloc(3)
        return path
    }

    public func applyTransform(transform: CGAffineTransform) {
//        let t =

        let t = NSAffineTransform()
        t.transformStruct = NSAffineTransformStruct(m11: transform.a, m12: transform.b, m21: transform.c, m22: transform.d, tX: transform.tx, tY: transform.ty)


        transformUsingAffineTransform(t)

    }

    #endif
}
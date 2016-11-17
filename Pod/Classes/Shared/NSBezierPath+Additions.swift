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
        let mid = CGPoint(x: rect.midX, y: rect.midY)
        let radius = rect.size.width / 2
        self.move(to: mid)
        
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

    public func addCurveToPoint(_ point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        curve(to: point, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
    }

    public func addLineToPoint(_ point: CGPoint) {
        line(to: point)
    }

    public func addArcWithCenter(_ center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        var startAngle = startAngle, endAngle = endAngle

        startAngle = toDegrees(Double(startAngle))
        endAngle = toDegrees(Double(endAngle))


        appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle)
    }
    #endif
}


// Taken from: https://gist.github.com/juliensagot/9749c3a1df28c38fb9f9
public extension XBezierPath {

    #if os(OSX)

    public var CGPath: CGPath {

        get {
            return self.transformToCGPath()
        }
    }

    /// Transforms the NSBezierPath into a CGPathRef
    ///
    /// :returns: The transformed NSBezierPath
    fileprivate func transformToCGPath() -> CGPath {

        // Create path
        let path = CGMutablePath()
        let points = UnsafeMutablePointer<NSPoint>.allocate(capacity: 3)
        let numElements = self.elementCount

        if numElements > 0 {

            var didClosePath = true

            for index in 0..<numElements {

                let pathType = self.element(at: index, associatedPoints: points)

                switch pathType {

                case .moveToBezierPathElement:
                    path.move(to: CGPoint(x: points[0].x, y: points[0].y))
                case .lineToBezierPathElement:
                    path.addLine(to: CGPoint(x: points[0].x, y: points[0].y))
                    didClosePath = false
                case .curveToBezierPathElement:
                    path.addCurve(to: CGPoint(x: points[0].x, y: points[0].y), control1: CGPoint(x: points[1].x, y: points[1].y), control2: CGPoint(x: points[2].x, y: points[2].y))
                    didClosePath = false
                case .closePathBezierPathElement:
                    path.closeSubpath()
                    didClosePath = true
                }
            }
            
            if !didClosePath { path.closeSubpath() }
        }
        
        points.deallocate(capacity: 3)
        return path
    }

    public func applyTransform(_ transform: CGAffineTransform) {
//        let t =

        let t = AffineTransform.identity
        (t as NSAffineTransform).transformStruct = NSAffineTransformStruct(m11: transform.a, m12: transform.b, m21: transform.c, m22: transform.d, tX: transform.tx, tY: transform.ty)


        self.transform(using: t)

    }

    #endif
}

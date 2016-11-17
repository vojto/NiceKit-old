//
//  NKDrawing.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 17/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public func NKCreateBorderRadiusPath(_ rect: CGRect, radius: CGFloat) -> CGPath {
    let path = CGMutablePath()
    path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
    path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.minY + radius), radius: radius, startAngle: CGFloat(3 * M_PI / 2.0), endAngle: 0, clockwise: false)
    path.addArc(center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius), radius: radius, startAngle: 0, endAngle: CGFloat(M_PI / 2.0), clockwise: false)
    path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: CGFloat(M_PI / 2.0), endAngle: CGFloat(M_PI), clockwise: false)
    path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle:  CGFloat(M_PI), endAngle: CGFloat(3 * M_PI / 2.0), clockwise: false)
    
    path.closeSubpath()
    return path
}


public func NKCreateBorderRadiusPath(_ rect: CGRect, topLeft: CGFloat, topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat) -> CGPath {
    let path = CGMutablePath()
    
    path.move(to: CGPoint(x: rect.minX + bottomLeft, y: rect.minY))
    path.addArc(center: CGPoint(x: rect.maxX - bottomRight, y: rect.minY + bottomRight), radius: bottomRight, startAngle: CGFloat(3 * M_PI / 2.0), endAngle: 0, clockwise: false)
    path.addArc(center: CGPoint(x: rect.maxX - topRight, y: rect.maxY - topRight), radius: topRight, startAngle: 0, endAngle: CGFloat(M_PI / 2.0), clockwise: false)
    path.addArc(center: CGPoint(x: rect.minX + topLeft, y: rect.maxY - topLeft), radius: topLeft, startAngle: CGFloat(M_PI / 2.0), endAngle: CGFloat(M_PI), clockwise: false)
    path.addArc(center: CGPoint(x: rect.minX + bottomLeft, y: rect.minY + bottomLeft), radius: bottomLeft, startAngle:  CGFloat(M_PI), endAngle: CGFloat(3 * M_PI / 2.0), clockwise: false)
    path.closeSubpath()
    return path
}

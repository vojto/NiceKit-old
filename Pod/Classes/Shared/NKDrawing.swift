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
    CGPathMoveToPoint(path, nil, rect.minX + radius, rect.minY)
    CGPathAddArc(path, nil, rect.maxX - radius, rect.minY + radius, radius, CGFloat(3 * M_PI / 2.0), 0, false)
    CGPathAddArc(path, nil, rect.maxX - radius, rect.maxY - radius, radius, 0, CGFloat(M_PI / 2.0), false)
    CGPathAddArc(path, nil, rect.minX + radius, rect.maxY - radius, radius, CGFloat(M_PI / 2.0), CGFloat(M_PI), false)
    CGPathAddArc(path, nil, rect.minX + radius, rect.minY + radius, radius, CGFloat(M_PI), CGFloat(3 * M_PI / 2.0), false)
    path.closeSubpath()
    return path
}


public func NKCreateBorderRadiusPath(_ rect: CGRect, topLeft: CGFloat, topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat) -> CGPath {
    let path = CGMutablePath()
    CGPathMoveToPoint(path, nil, rect.minX + bottomLeft, rect.minY)
    CGPathAddArc(path, nil, rect.maxX - bottomRight, rect.minY + bottomRight, bottomRight, CGFloat(3 * M_PI / 2.0), 0, false)
    CGPathAddArc(path, nil, rect.maxX - topRight, rect.maxY - topRight, topRight, 0, CGFloat(M_PI / 2.0), false)
    CGPathAddArc(path, nil, rect.minX + topLeft, rect.maxY - topLeft, topLeft, CGFloat(M_PI / 2.0), CGFloat(M_PI), false)
    CGPathAddArc(path, nil, rect.minX + bottomLeft, rect.minY + bottomLeft, bottomLeft, CGFloat(M_PI), CGFloat(3 * M_PI / 2.0), false)
    path.closeSubpath()
    return path
}

//
//  NKDrawing.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 17/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public func NKCreateBorderRadiusPath(rect: CGRect, radius: CGFloat) -> CGPathRef {
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect))
    CGPathAddArc(path, nil, CGRectGetMaxX(rect) - radius, CGRectGetMinY(rect) + radius, radius, CGFloat(3 * M_PI / 2.0), 0, false)
    CGPathAddArc(path, nil, CGRectGetMaxX(rect) - radius, CGRectGetMaxY(rect) - radius, radius, 0, CGFloat(M_PI / 2.0), false)
    CGPathAddArc(path, nil, CGRectGetMinX(rect) + radius, CGRectGetMaxY(rect) - radius, radius, CGFloat(M_PI / 2.0), CGFloat(M_PI), false)
    CGPathAddArc(path, nil, CGRectGetMinX(rect) + radius, CGRectGetMinY(rect) + radius, radius, CGFloat(M_PI), CGFloat(3 * M_PI / 2.0), false)
    CGPathCloseSubpath(path)
    return path
}


public func NKCreateBorderRadiusPath(rect: CGRect, topLeft: CGFloat, topRight: CGFloat, bottomRight: CGFloat, bottomLeft: CGFloat) -> CGPathRef {
    let path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, CGRectGetMinX(rect) + bottomLeft, CGRectGetMinY(rect))
    CGPathAddArc(path, nil, CGRectGetMaxX(rect) - bottomRight, CGRectGetMinY(rect) + bottomRight, bottomRight, CGFloat(3 * M_PI / 2.0), 0, false)
    CGPathAddArc(path, nil, CGRectGetMaxX(rect) - topRight, CGRectGetMaxY(rect) - topRight, topRight, 0, CGFloat(M_PI / 2.0), false)
    CGPathAddArc(path, nil, CGRectGetMinX(rect) + topLeft, CGRectGetMaxY(rect) - topLeft, topLeft, CGFloat(M_PI / 2.0), CGFloat(M_PI), false)
    CGPathAddArc(path, nil, CGRectGetMinX(rect) + bottomLeft, CGRectGetMinY(rect) + bottomLeft, bottomLeft, CGFloat(M_PI), CGFloat(3 * M_PI / 2.0), false)
    CGPathCloseSubpath(path)
    return path
}
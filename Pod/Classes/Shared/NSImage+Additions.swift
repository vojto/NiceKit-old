//
//  NSImage+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 03/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
    import AppKit
#else
    import UIKit
#endif

public extension XImage {
    #if os(OSX)
    var CGImage: CGImageRef? {
        let ctx = NSGraphicsContext.currentContext()
        var rect = CGRectMake(0, 0, size.width, size.height)
        return self.CGImageForProposedRect(&rect, context: ctx, hints: nil)
    }
    #else
    #endif

    func draw(color: XColor, drawRect: CGRect, flip: Bool = false) {
        let rect: CGRect = drawRect
        let image = self
        let imageRef = image.CGImage
        let ctx = XGraphicsGetCurrentContext()

//        let ctx = NSGraphicsContext.currentContext()
//        let cgCtx = ctx?.CGContext
//        let imageRef = image.CGImageForProposedRect(nil, context: ctx, hints: nil)

        CGContextSaveGState(ctx)
        
        if flip {
            CGContextTranslateCTM(ctx, 0, rect.size.height + rect.origin.y*2)
            CGContextScaleCTM(ctx, 1, -1)
        }
        
        
        CGContextClipToMask(ctx, rect, imageRef)
        
        color.set()

//        NSRectFillUsingOperation(rect, .CompositeSourceOver)
        CGContextFillRect(ctx, rect)

        CGContextRestoreGState(ctx)
    }

    #if os (OSX)
    #else
    func colorize(color: XColor) -> XImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let ctx = UIGraphicsGetCurrentContext()

        CGContextTranslateCTM(ctx, 0, size.height)
        CGContextScaleCTM(ctx, 1.0, -1.0)
        CGContextSetBlendMode(ctx, .Normal)
        let rect = CGRectMake(0, 0, size.width, size.height)
        CGContextClipToMask(ctx, rect, CGImage)
        color.setFill()
        CGContextFillRect(ctx, rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    #endif
}
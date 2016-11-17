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
    var CGImage: CGImage? {
        let ctx = NSGraphicsContext.current()
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return self.cgImage(forProposedRect: &rect, context: ctx, hints: nil)
    }
    #else
    #endif

    func draw(_ color: XColor, drawRect: CGRect, flip: Bool = false) {
        let rect: CGRect = drawRect
        let image = self
        let imageRef = image.CGImage
        let ctx = XGraphicsGetCurrentContext()

//        let ctx = NSGraphicsContext.currentContext()
//        let cgCtx = ctx?.CGContext
//        let imageRef = image.CGImageForProposedRect(nil, context: ctx, hints: nil)

        ctx.saveGState()
        
        if flip {
            ctx.translateBy(x: 0, y: rect.size.height + rect.origin.y*2)
            ctx.scaleBy(x: 1, y: -1)
        }
        
        
        ctx.clip(to: rect, mask: imageRef!)
        
        color.set()

//        NSRectFillUsingOperation(rect, .CompositeSourceOver)
        ctx.fill(rect)

        ctx.restoreGState()
    }

    #if os (OSX)
    #else
    public func colorize(color: XColor) -> XImage {
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
    

    public func tintedImageWithColor(_ color: NSColor) -> NSImage {
        let size        = self.size
        let imageBounds = NSMakeRect(0, 0, size.width, size.height)
        let copiedImage = self.copy() as! NSImage
        
        copiedImage.lockFocus()
        color.set()
        NSRectFillUsingOperation(imageBounds, .sourceAtop)
        copiedImage.unlockFocus()
        
        return copiedImage
    }
    
}

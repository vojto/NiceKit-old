//
//  XView+Rendering.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
#if os(iOS)
import UIKit
#else
import AppKit
#endif

extension XView {
#if os(OSX)
    func renderToImage() -> XImage {
        let frame = self.bounds
        let size = frame.size

        let backingSize = self.convertSizeToBacking(size)
        let scale = backingSize.width / size.width


        let rep = NSBitmapImageRep(
            bitmapDataPlanes: nil,
            pixelsWide: Int(backingSize.width),
            pixelsHigh: Int(backingSize.height),
            bitsPerSample: 8,
            samplesPerPixel: 4,
            hasAlpha: true,
            isPlanar: false,
            colorSpaceName: NSCalibratedRGBColorSpace,
            bitmapFormat: .NSAlphaFirstBitmapFormat,
            bytesPerRow: 4 * Int(backingSize.width),
            bitsPerPixel: 32)!

        NSGraphicsContext.saveGraphicsState()

        let context = NSGraphicsContext(bitmapImageRep: rep)!

        NSGraphicsContext.setCurrentContext(context)
        CGContextScaleCTM(context.CGContext, scale, scale)

        self.displayRectIgnoringOpacity(frame, inContext: context)

        NSGraphicsContext.restoreGraphicsState()

        let image = NSImage(size: size)
        image.addRepresentation(rep)

        return image
    }
#else
    func renderToImage() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
    let ctx = UIGraphicsGetCurrentContext()
    layer.renderInContext(ctx!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    return image
    }
#endif
}
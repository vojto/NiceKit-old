//
//  NKBezierPath.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 18/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

open class NKBezierPath: XBezierPath {
    open var size: CGSize?

    open func renderToImage(_ size: CGSize) -> XImage {
        let size = self.size ?? self.bounds.size

        let scaleX = size.width / size.width
        let scaleY = size.height / size.height

        let path = self.copy() as! NKBezierPath
        path.applyTransform(CGAffineTransform(scaleX: scaleX, y: scaleY))

        let view = NKBezierPathView(bezierPath: path as XBezierPath, frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        return view.renderToImage()
    }

    open func renderToImage() -> XImage {
        return renderToImage(self.size!)
    }
}

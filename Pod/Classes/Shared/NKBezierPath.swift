//
//  NKBezierPath.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 18/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public class NKBezierPath: XBezierPath {
    public var size: CGSize?

    public func renderToImage(size: CGSize) -> XImage {
        let size = self.size ?? self.bounds.size

        let scaleX = size.width / size.width
        let scaleY = size.height / size.height

        let path = self.copy() as! NKBezierPath
        path.applyTransform(CGAffineTransformMakeScale(scaleX, scaleY))

        let view = NKBezierPathView(bezierPath: path as! XBezierPath, frame: CGRectMake(0, 0, size.width, size.height))
        return view.renderToImage()
    }

    public func renderToImage() -> XImage {
        return renderToImage(self.size!)
    }
}
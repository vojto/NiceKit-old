//
//  NKBezierPathView.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 18/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

class NKBezierPathView: XView {
    var bezierPath: XBezierPath

    init(bezierPath: XBezierPath, frame: CGRect) {
        self.bezierPath = bezierPath

        super.init(frame: frame)

        #if os(iOS)
        self.opaque = false
        #endif
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {

        XColor.blackColor().setFill()

        bezierPath.fill()
    }
}
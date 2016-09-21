//
//  NKSlider.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 13/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

open class NKSlider: XSlider {
    open var onChange: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)

        #if os(OSX)
        target = self
        action = #selector(NKSlider.handleSlide)
        #else
        addTarget(self, action: "handleSlide", forControlEvents: .ValueChanged)
        #endif
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func handleSlide() {
        onChange?()
    }


    #if os(OSX)

    open var minimumValue: Double {
        get { return minValue }
        set { minValue = newValue }
    }

    open var maximumValue: Double {
        get { return maxValue }
        set { maxValue = newValue }
    }

    open var value: Float {
        get { return Float(doubleValue) }
        set { doubleValue = Double(newValue) }
    }

    #else
    #endif
}

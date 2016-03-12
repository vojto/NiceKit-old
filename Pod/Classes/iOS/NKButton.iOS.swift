//
//  NKButton.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics



import UIKit

public class NKButton: XButton, NKViewable {
    public var style: NKStyle
    public var classes = Set<String>()

    public var isActive = false {
        didSet {
            isActive ? addClass("active") : removeClass("active")
            applyStyle()
        }
    }

    public override var enabled: Bool {
        didSet {
            enabled ? removeClass("disabled") : addClass("disabled")
            applyStyle()
        }
    }

    public var action: (() -> ())? {
        get { return onTap }
        set { onTap = newValue }
    }
    public var onTap: NKSimpleCallback?
    public var onTouchDown: NKSimpleCallback?
    public var onClick: NKSimpleCallback?       // Doesn't do anything on iOS

    public var image: XImage? {
        get {
            return imageForState(.Normal)
        }
        set {
            let image = newValue?.imageWithRenderingMode(.AlwaysTemplate)
            setImage(image, forState: .Normal)
        }
    }

    public var title: String? {
        get {
            return titleLabel?.text
        }

        set {
            setTitle(newValue, forState: .Normal)
        }
    }

    public init() {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: CGRectZero)

        setup()

        addTarget(self, action: "handleTouchDown", forControlEvents: .TouchDown)
        addTarget(self, action: "handleTouchUpOutside", forControlEvents: .TouchUpOutside)
        addTarget(self, action: "handleTouchUpInside", forControlEvents: .TouchUpInside)

        adjustsImageWhenHighlighted = false

//            applyStyle()

        // TODO: Apply style to the view/layers
    }

    public convenience init(title: String) {
        self.init()

        self.title = title
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {
    }

    public func applyStyle() {
        titleLabel?.font = style.font

        if let color = style.textColor?.color {
            titleLabel?.textColor = color
            imageView?.tintColor = color
        }

        contentEdgeInsets = style.padding.edgeInsets

        if let textAlign = style.textAlign {
            switch(textAlign) {
            case .Left: contentHorizontalAlignment = .Left
            case .Center: contentHorizontalAlignment = .Center
            case .Right: contentHorizontalAlignment = .Right
            }
        }

        if let opacity = style.opacity {
            self.alpha = opacity
        } else {
            self.alpha = 1
        }

        setNeedsDisplay()
    }

    public override func drawRect(rect: CGRect) {
        style.draw(rect)

        super.drawRect(rect)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        applyStyle()
    }

    // MARK: Handling events

    func handleTouchDown() {
        isActive = true
        onTouchDown?()
    }

    func handleTouchUpInside() {
        isActive = false
        action?()
    }

    func handleTouchUpOutside() {
        isActive = false
    }

    public override func setTitle(title: String?, forState state: UIControlState) {
        if style.textTransform == .Uppercase {
            super.setTitle(title?.uppercaseString, forState: state)
        } else {
            super.setTitle(title, forState: state)
        }
    }
}


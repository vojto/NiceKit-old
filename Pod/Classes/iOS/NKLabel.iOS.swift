//
//  NKLabel.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


public class NKLabel: XLabel, NKViewable {
    public var style: NKStyle
    public var classes = Set<String>()

    public var tapRecognizer: UITapGestureRecognizer?
    public var onTap: (() -> ())? {
        didSet {
            if tapRecognizer == nil {
                tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
                addGestureRecognizer(tapRecognizer!)
            }
            userInteractionEnabled = true
        }
    }
    public var onClick: NKSimpleCallback?
    public var onAction: (() -> ())? {
        get { return onTap }
        set { onTap = newValue }
    }

    public override init(frame: CGRect) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: frame)

        lineBreakMode = .ByWordWrapping
        numberOfLines = 0


        setup()
    }

    public override var text: String? {
        get { return super.text }
        set {
            if self.style.textTransform == .Uppercase {
                super.text = newValue?.uppercaseString
            } else {
                super.text = newValue
            }
        }
    }

    public func setup() {
    }

    public convenience init(text: String) {
        self.init(frame: CGRectZero)

        self.text = text
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func applyStyle() {
        self.font = style.font
        if let color = style.textColor {
            self.textColor = color.color
        }

        if let textAlign = style.textAlign {
            switch(textAlign) {
            case .Left: textAlignment = .Left
            case .Center: textAlignment = .Center
            case .Right: textAlignment = .Right
            }
        }

        if let opacity = style.opacity {
            alpha = opacity
        }

        if let background = style.background {
            backgroundColor = background.color
        }

    }

    func handleTap() {
        onTap?()
    }

    public override func willMoveToSuperview(newSuperview: XView?) {
        super.willMoveToSuperview(newSuperview)
        self.applyStyle()
    }


}

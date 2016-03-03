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


class NKLabel: XLabel, NKViewable {
    var style: NKStyle
    var classes = Set<String>()

    var tapRecognizer: UITapGestureRecognizer?
    var onTap: (() -> ())? {
        didSet {
            if tapRecognizer == nil {
                tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
                addGestureRecognizer(tapRecognizer!)
            }
            userInteractionEnabled = true
        }
    }
    var onClick: NKSimpleCallback?
    var onAction: (() -> ())? {
        get { return onTap }
        set { onTap = newValue }
    }

    override init(frame: CGRect) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: frame)

        lineBreakMode = .ByWordWrapping
        numberOfLines = 0


        setup()
    }

    override var text: String? {
        get { return super.text }
        set {
            if self.style.textTransform == .Uppercase {
                super.text = newValue?.uppercaseString
            } else {
                super.text = newValue
            }
        }
    }

    func setup() {
    }

    convenience init(text: String) {
        self.init(frame: CGRectZero)

        self.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyStyle() {
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

    override func willMoveToSuperview(newSuperview: XView?) {
        super.willMoveToSuperview(newSuperview)
        self.applyStyle()
    }


}

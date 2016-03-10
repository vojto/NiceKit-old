//
//  NKTextField.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 13/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit


public class NKTextField: XTextField, NKViewable, UITextFieldDelegate {
    public var bezeled = false // TODO: Use iOS style api instead
    public var style: NKStyle
    public var classes = Set<String>()

    public var onFocus: NKSimpleCallback?
    public var onBlur: NKSimpleCallback?
    public var onSubmit: NKSimpleCallback?

    public var nextKeyView: XView? // Not used here on iOS

    public var fieldType: NKFieldType? {
        didSet {
            if fieldType == .Email {
                autocorrectionType = .No
                autocapitalizationType = .None
                keyboardType = .EmailAddress
            } else if fieldType == .Password {
                autocorrectionType = .No
                autocapitalizationType = .None
                secureTextEntry = true // TODO: Won't work on Mac
            }
        }
    }

    public var secureValue: String? { return text }

    public override init(frame: CGRect) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: frame)

        self.delegate = self

        applyStyle()
    }

    public convenience init(placeholder: String) {
        self.init(frame: CGRectZero)

        self.placeholder = placeholder
    }

    public convenience init(attributedPlaceholder: NSAttributedString) {
        self.init(frame: CGRectZero)

        self.attributedPlaceholder = attributedPlaceholder
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func applyStyle() {
        self.font = style.font
        if let color = style.textColor {
            self.textColor = color.color
        }
    }

    public func blur() {
        resignFirstResponder()
    }

    public override func willMoveToSuperview(newSuperview: XView?) {
        super.willMoveToSuperview(newSuperview)
        self.applyStyle()
    }

    public override func textRectForBounds(var bounds: CGRect) -> CGRect {
        let padding = style.padding
        bounds.origin.x += padding.left
        bounds.origin.y += padding.bottom
        bounds.size.width -= padding.horizontal
        bounds.size.height -= padding.vertical

        return bounds
    }

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

    
    public override func drawRect(rect: CGRect) {
        style.draw(rect)

        super.drawRect(rect)
    }


    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        onFocus?()
        return true
    }

    public func textFieldDidEndEditing(textField: UITextField) {
        onBlur?()
    }

    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        onSubmit?()
        return true
    }

}
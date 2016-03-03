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


class NKTextField: XTextField, NKViewable, UITextFieldDelegate {
    var bezeled = false // TODO: Use iOS style api instead
    var style: NKStyle
    var classes = Set<String>()

    var onFocus: SimpleCallback?
    var onBlur: SimpleCallback?
    var onSubmit: SimpleCallback?

    var nextKeyView: XView? // Not used here on iOS

    var fieldType: NKFieldType? {
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

    var secureValue: String? { return text }

    override init(frame: CGRect) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: frame)

        self.delegate = self

        applyStyle()
    }

    convenience init(placeholder: String) {
        self.init(frame: CGRectZero)

        self.placeholder = placeholder
    }

    convenience init(attributedPlaceholder: NSAttributedString) {
        self.init(frame: CGRectZero)

        self.attributedPlaceholder = attributedPlaceholder
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func applyStyle() {
        self.font = style.font
        if let color = style.textColor {
            self.textColor = color.color
        }
    }

    func blur() {
        resignFirstResponder()
    }

    override func willMoveToSuperview(newSuperview: XView?) {
        super.willMoveToSuperview(newSuperview)
        self.applyStyle()
    }

    override func textRectForBounds(var bounds: CGRect) -> CGRect {
        let padding = style.padding
        bounds.origin.x += padding.left
        bounds.origin.y += padding.bottom
        bounds.size.width -= padding.horizontal
        bounds.size.height -= padding.vertical

        return bounds
    }

    override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return textRectForBounds(bounds)
    }

    
    override func drawRect(rect: CGRect) {
        style.draw(rect)

        super.drawRect(rect)
    }


    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        onFocus?()
        return true
    }

    func textFieldDidEndEditing(textField: UITextField) {
        onBlur?()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        onSubmit?()
        return true
    }

}
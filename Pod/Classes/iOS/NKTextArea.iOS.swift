//
//  NKTextField.iOS.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 05/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit

class NKTextArea: UITextView, NKViewable {
    // TODO: Implement this for UITextView, or just use UITextField somehow... 
    // See: http://stackoverflow.com/questions/1328638/placeholder-in-uitextview
    var attributedPlaceholder: NSAttributedString?

    var delegateRetainer = NKTextAreaDelegate()

    var onFocus: (() -> ())?
    var onBlur: (() -> ())?
    var onChange: (() -> ())?

    var bezeled: Bool = false // TODO: Doesn't do anything, should it?

    var style: NKStyle
    var classes = Set<String>()

    var isFieldFocused = false {
        didSet {
            setNeedsDisplay()
        }
    }

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: frame, textContainer: textContainer)

        textContainerInset = UIEdgeInsetsZero

        scrollEnabled = false


        editable = true

        delegateRetainer.field = self
        delegate = delegateRetainer

        backgroundColor = XColor.clearColor()
    }

    override var editable: Bool {
        didSet {
            userInteractionEnabled = editable
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        textContainer.lineFragmentPadding = 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        if let placeholder = attributedPlaceholder where text.characters.count == 0 && !isFieldFocused {
            placeholder.drawInRect(bounds)
        }
    }

    func applyStyle() {
        self.font = style.font
        if let color = style.textColor {
            self.textColor = color.color
        }

        if let background = style.background {
            self.backgroundColor = background.color
        }
    }

    override func willMoveToSuperview(newSuperview: XView?) {
        super.willMoveToSuperview(newSuperview)
        self.applyStyle()
    }
}

class NKTextAreaDelegate: NSObject, UITextViewDelegate {
    var field: NKTextArea!


    override init() {
    }

    func textViewDidChange(textView: UITextView) {
        field.onChange?()
    }

    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }

    func textViewDidBeginEditing(textView: UITextView) {
        field.isFieldFocused = true
        field.onFocus?()
        NSNotificationCenter.post("NKTextArea.focus", field)
    }

    func textViewDidEndEditing(textView: UITextView) {
        NSNotificationCenter.post("NKTextArea.blur", field)
        field.isFieldFocused = false
        field.onBlur?()
    }

    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            field.resignFirstResponder()
            return false
        }

        return true
    }
}
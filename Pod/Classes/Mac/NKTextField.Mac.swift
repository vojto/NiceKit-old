//
//  NKTextField.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cocoa
import CoreGraphics
import Changeset


enum NKAutocorrectionType {
    case No
}

enum NKAutocapitalizationType {
    case None
}

enum NKKeyboardType {
    case NumberPad
}


public class NKTextField: NSTextField, NKViewable {
    var transientDelegate: NKTextFieldDelegate

    public var style: NKStyle
    public var placeholderStyle: NKStyle
    public var classes = Set<String>()

    public var onChange: NKSimpleCallback?
    public var onCancel: NKSimpleCallback?
    public var onBlur: NKSimpleCallback?
    public var onFocus: NKSimpleCallback?
    public var onSubmit: NKSimpleCallback?

    public var onAction: NKSimpleCallback? {
        get { return onClick }
        set { onClick = newValue }
    }

    public var onClick: NKSimpleCallback?
    public var onMouseDown: (NSEvent -> Void)?
    var onMouseUp: (NSEvent -> Void)?

    var autocorrectionType: NKAutocorrectionType?
    var autocapitalizationType: NKAutocapitalizationType?
    var keyboardType: NKKeyboardType?

    public var fieldType: NKFieldType?
    public var secureValue: String = ""

    public override var placeholder: String? {
        get { return super.placeholder }
        set {
            let str = NSMutableAttributedString(string: newValue!)
            str.font = placeholderStyle.font
            str.textColor = placeholderStyle.textColor?.color
            super.placeholderAttributedString = str
        }
    }

//    override var text: String? {
//        get { return super.text }
//        set {
//            super.text = newValue
//            applyStyle()
//        }
//    }

    // MARK: - Lifecycle
    // ----------------------------------------------------------------------

    public override init(frame frameRect: NSRect) {
        self.style = NKStylesheet.styleForView(self.dynamicType)
        self.placeholderStyle = NKStylesheet.styleForView(self.dynamicType, classes: ["placeholder"])

        self.transientDelegate = NKTextFieldDelegate()
        
        super.init(frame: frameRect)
        
        self.delegate = self.transientDelegate
        
        self.transientDelegate.textField = self

        self.drawsBackground = false
        self.backgroundColor = XColor.clearColor()
        self.bordered = false

        self.focusRingType = .None

        applyStyle()
    }

    public convenience init(placeholder: String) {
        self.init(frame: CGRectZero)

        self.placeholder = placeholder
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func layoutSubtreeIfNeeded() {
        super.layoutSubtreeIfNeeded()
        applyStyle()
    }

    // MARK: - Style support
    // ----------------------------------------------------------------------

    public func applyStyle() {
        font = style.font

        if let color = style.textColor {
            self.textColor = color.color
        }

        if let opacity = style.opacity {
            self.alpha = opacity
        } else {
            self.alpha = 1
        }

        if let align = style.textAlign {
            switch(align) {
            case .Left: textAlignment = .Left
            case .Center: textAlignment = .Center
            case .Right: textAlignment = .Right
            }
        }

        if let background = style.background {
            self.backgroundColor = background.color
            self.drawsBackground = true
        }

//        let text = style.prepareAttributedString(self.text!)
//        self.attributedStringValue = text
    }


    // MARK: - Events
    // ----------------------------------------------------------------------
    
    func handleClickFromTable(event: NSEvent) {
        if self.editable {
            self.window?.makeFirstResponder(self)
        }
    }

    override public func textDidEndEditing(notification: NSNotification) {
        super.textDidEndEditing(notification)
        onBlur?()
    }

    override public func textDidBeginEditing(notification: NSNotification) {
        super.textDidBeginEditing(notification)
        onFocus?()
    }

    func blur() {
        window?.makeFirstResponder(nil)
    }

    func focus() {
        window?.makeFirstResponder(self)
    }

    var hasClickHandler: Bool {
        return onMouseDown != nil || onMouseUp != nil || onClick != nil
    }

    public override func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        onMouseDown?(theEvent)
    }

    public override func mouseUp(theEvent: NSEvent) {
        super.mouseUp(theEvent)
        onMouseUp?(theEvent)
        onClick?()
    }

//    override func drawRect(dirtyRect: NSRect) {
//        if fieldType == .Password {
//            self.drawSecureField(dirtyRect)
//        } else {
//            super.drawRect(dirtyRect)
//        }
//    }

//    func drawSecureField(dirtyRect: NSRect) {
//        let value = stringValue
//
//        stringValue = "geno"
//
//        super.drawRect(dirtyRect)
//
//        stringValue = value
//    }

    var lastValue: String = ""

    public override var stringValue: String {
        get {
            return super.stringValue
        }
        set {
            self.lastValue = newValue
            super.stringValue = newValue
        }
    }


}

class NKTextFieldDelegate: NSObject, NSTextFieldDelegate {
    var textField: NKTextField!

    override func controlTextDidChange(notification: NSNotification) {
        if textField.fieldType == .Password {
            let lastValue = textField.lastValue
            let currentValue = textField.text ?? ""

            self.applyChangeToSecureValue(lastValue, target: currentValue)

            let char = "●".characters.first!
        textField.stringValue = String(Array(count: currentValue.characters.count as Int, repeatedValue: char))
        }


        textField.onChange?()
    }

    func applyChangeToSecureValue(source: String, target: String) {
        let changeset = Changeset(source: source.characters, target: target.characters)

        let secureValue = textField.secureValue
//
        var chars = Array(secureValue.characters)
//
        var toDelete = [Int]()

        for edit in changeset.edits {
            switch (edit.operation) {
            case .Insertion:
                chars.insert(edit.value, atIndex: edit.destination)
            case .Substitution:
                chars[edit.destination] = edit.value
            case .Deletion:
                //                chars.removeAtIndex(edit.destination)
                toDelete.append(edit.destination)
            case .Move(let  origin):
                chars.removeAtIndex(origin)
                chars.insert(edit.value, atIndex: edit.destination)

            }
        }

        for index in toDelete.reverse() {
            chars.removeAtIndex(index)
        }

        textField.secureValue = String(chars)
    }


    func control(control: NSControl, textView: NSTextView, doCommandBySelector commandSelector: Selector) -> Bool {
        if String(commandSelector) == "cancelOperation:" {
            textField.onCancel?()
            return true
        } else if String(commandSelector) == "insertNewline:" {
            textField.onSubmit?()
            return true
        }

        return false
    }
}
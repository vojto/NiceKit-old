//
//  XLabel+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 04/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

public extension NSTextField {
    public var text: String? {
        get { return stringValue }
        set { stringValue = newValue ?? "" }
    }

    public var attributedText: NSAttributedString? {
        get { return attributedStringValue }
        set { attributedStringValue = newValue ?? NSAttributedString(string: "") }
    }

    public var textAlignment: NSTextAlignment {
        get { return alignment }
        set { alignment = newValue }
    }
}
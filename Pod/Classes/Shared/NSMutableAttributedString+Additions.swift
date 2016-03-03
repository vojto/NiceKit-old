//
//  NSAttributedString+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
#if os(OSX)
import AppKit
#endif

public extension NSMutableAttributedString {
    func addAttribute(name: String, value: AnyObject) {
        self.addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }
    
    func attributeValue(name: String) -> AnyObject? {
        var range = NSMakeRange(0, self.length)
        return self.attribute(name, atIndex: 0, effectiveRange: &range)
    }
    
    func removeAttribute(name: String) {
        self.removeAttribute(name, range: NSMakeRange(0, self.length))
    }
    
    func replaceAttribute(name: String, newValue: AnyObject?) {
        self.removeAttribute(name)
        if let value = newValue {
            self.addAttribute(name, value: value)
        }
    }

    var attributes: [String: AnyObject] {
        let range = NSMakeRange(0, self.length)

        var attributes = [String: AnyObject]()

        self.enumerateAttributesInRange(range, options: NSAttributedStringEnumerationOptions()) { (dct, range, bazinga) -> Void in
            attributes += dct
        }

        return attributes
    }
    
    public var textColor: XColor? {
        get {
            return self.attributeValue(XForegroundColorAttributeName) as? XColor
        }
        set {
            self.replaceAttribute(XForegroundColorAttributeName, newValue: newValue)
        }
    }
    
    public var font: XFont? {
        get {
            return self.attributeValue(XFontAttributeName) as? XFont
        }
        set {
            self.replaceAttribute(XFontAttributeName, newValue: newValue)
        }
    }
    
    public var strikethroughStyle: Int? {
        get {
            return self.attributeValue(XStrikethroughStyleAttributeName) as? Int
        }
        set {
            self.replaceAttribute(XStrikethroughStyleAttributeName, newValue: newValue)
        }
    }

    #if os(OSX)
    public var style: NSParagraphStyle? {
        get { return self.attributeValue(NSParagraphStyleAttributeName) as? NSParagraphStyle }
        set {
            self.replaceAttribute(NSParagraphStyleAttributeName, newValue: newValue)
        }
    }
    #endif
}

func +=(lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.appendAttributedString(rhs)
}

func +=(lhs: NSMutableAttributedString, rhs: String) {
    lhs.appendAttributedString(NSAttributedString(string: rhs))
}

func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let str1 = lhs.mutableCopy() as! NSMutableAttributedString
    str1.appendAttributedString(rhs)
    return str1
}

func +(lhs: String, rhs: NSAttributedString) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(string: lhs)
    str.appendAttributedString(rhs)
    return str
}
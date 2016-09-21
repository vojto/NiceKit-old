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
    func addAttribute(_ name: String, value: AnyObject) {
        self.addAttribute(name, value: value, range: NSMakeRange(0, self.length))
    }
    
    func attributeValue(_ name: String) -> AnyObject? {
        var range = NSMakeRange(0, self.length)
        return self.attribute(name, at: 0, effectiveRange: &range) as AnyObject?
    }
    
    func removeAttribute(_ name: String) {
        self.removeAttribute(name, range: NSMakeRange(0, self.length))
    }
    
    func replaceAttribute(_ name: String, newValue: AnyObject?) {
        self.removeAttribute(name)
        if let value = newValue {
            self.addAttribute(name, value: value)
        }
    }

    var attributes: [String: AnyObject] {
        let range = NSMakeRange(0, self.length)

        var attributes = [String: AnyObject]()

        self.enumerateAttributes(in: range, options: NSAttributedString.EnumerationOptions()) { (dct, range, bazinga) -> Void in
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
            self.replaceAttribute(XStrikethroughStyleAttributeName, newValue: newValue as AnyObject?)
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

public func +=(lhs: NSMutableAttributedString, rhs: NSAttributedString) {
    lhs.append(rhs)
}

public func +=(lhs: NSMutableAttributedString, rhs: String) {
    lhs.append(NSAttributedString(string: rhs))
}

public func +(lhs: NSAttributedString, rhs: NSAttributedString) -> NSAttributedString {
    let str1 = lhs.mutableCopy() as! NSMutableAttributedString
    str1.append(rhs)
    return str1
}

public func +(lhs: String, rhs: NSAttributedString) -> NSMutableAttributedString {
    let str = NSMutableAttributedString(string: lhs)
    str.append(rhs)
    return str
}

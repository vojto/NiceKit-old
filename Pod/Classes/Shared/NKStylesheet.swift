//
//  NKStylesheet.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 27/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias StyleCallback = ((builder: NKStyleBuilder) -> ())

public class NKStylesheet: NKStylesheetEntry {
    public static var stylesheet: NKStylesheet?

    public init() {
        super.init(cls: "root")
    }

    public static func styleForClasses(var classes: [String]) -> NKStyle {
        let style = NKStyle()

        #if os(OSX)
        classes.append("osx")
        #elseif os(iOS)
        classes.append("ios")
        #endif

//        print("Getting style for classes: \(classes)")

        if let stylesheet = self.stylesheet {
            stylesheet.addStylesFromChildEntriesMatching(classes, toStyle: style)
        }

        return style
    }

    public static func styleForView(view: AnyClass) -> NKStyle {
        return styleForView(view, classes: [])
    }

    public static func styleForView(view: AnyClass, var classes: [String]) -> NKStyle {
//        Log.t("Getting style for view: \(view)")
        let viewName = NSStringFromClass(view)
//        Log.t("    viewName = \(viewName)")
        let cls = viewName.componentsSeparatedByString(".").last!
        classes.insert(cls, atIndex: 0)
        return styleForClasses(classes)
    }
}

public class NKStylesheetEntry: CustomDebugStringConvertible {
    let cls: String
    let style: NKStyle
    var childEntries = [NKStylesheetEntry]()

    init(cls: String) {
        self.cls = cls
        self.style = NKStyle()
    }

    public func style(cls: String, handler: StyleCallback) {
        let builder = NKStyleBuilder(style: self.style, entry: self)
        builder.style(cls, handler: handler)
    }

    public func style(classes: [String], handler: StyleCallback) {
        for cls in classes {
            self.style(cls, handler: handler)
        }
    }

    public var debugDescription: String {
        return "<\(cls) \(childEntries) >"
    }

    func addStylesFromChildEntriesMatching(classes: [String], toStyle style: NKStyle) {
        let matchingEntries = self.childEntries.filter { childEntry in
            classes.contains(childEntry.cls)
        }

        for entry in matchingEntries {
//            print("Adding style from \(entry)")
            entry.addStyle(toStyle: style)
        }

        for entry in matchingEntries {
            entry.addStylesFromChildEntriesMatching(classes, toStyle: style)
        }
    }

    func addStyle(toStyle style: NKStyle) {
        style.mergePropertiesFrom(style: self.style)
    }
}

public class NKStyleBuilder {
    public let style: NKStyle
    let entry: NKStylesheetEntry

    public init(style: NKStyle, entry: NKStylesheetEntry) {
        self.style = style
        self.entry = entry
    }

    public func style(cls: String, handler: StyleCallback) {
        let childEntry = NKStylesheetEntry(cls: cls)
        self.entry.childEntries.append(childEntry)

        let builder = NKStyleBuilder(style: childEntry.style, entry: childEntry)
        handler(builder: builder)


    }

    public var opaque: Bool? {
        get { return style.opaque }
        set { style.opaque = newValue }
    }

    public var opacity: CGFloat? {
        get { return style.opacity }
        set { style.opacity = newValue }
    }

    public var backgroundColor: NKColor? {
        get { return style.backgroundColor }
        set { style.backgroundColor = newValue }
    }

    public var background: NKColor? {
        get { return style.background }
        set { style.background = newValue }
    }

    public var textColor: NKColor? {
        get { return style.textColor }
        set { style.textColor = newValue }
    }

    public var textAlign: NKTextAlign? {
        get { return style.textAlign }
        set { style.textAlign = newValue }
    }

    public var image: String? {
        get { return style.image }
        set { style.image = newValue }
    }

    public var fontSize: CGFloat? {
        get { return style.fontSize }
        set { style.fontSize = newValue }
    }

    public var fontWeight: NKFontWeight? {
        get { return style.fontWeight }
        set { style.fontWeight = newValue }
    }

    public var font: XFont? {
        get { return style.font }
        set { style.font = newValue }
    }

    public var border: (CGFloat?, NKColor?) {
        get { return style.border }
        set { style.border = newValue }
    }

    public var borderRadius: CGFloat? {
        get { return style.borderRadius }
        set { style.borderRadius = newValue }
    }

    public var borderTop: (CGFloat?, NKColor?) {
        get { return style.borderTop }
        set { style.borderTop = newValue }
    }

    public var borderRight: (CGFloat?, NKColor?) {
        get { return style.borderRight }
        set { style.borderRight = newValue }
    }

    public var borderBottom: (CGFloat?, NKColor?) {
        get { return style.borderBottom }
        set { style.borderBottom = newValue }
    }

    public var borderLeft: (CGFloat?, NKColor?) {
        get { return style.borderLeft }
        set { style.borderLeft = newValue }
    }

    public var padding: NKPadding {
        get { return style.padding }
        set { style.padding = newValue }
    }

    public var paddingTop: CGFloat? {
        get { return style.paddingTop }
        set { style.paddingTop = newValue }
    }

    public var paddingRight: CGFloat? {
        get { return style.paddingRight }
        set { style.paddingRight = newValue }
    }

    public var paddingBottom: CGFloat? {
        get { return style.paddingBottom }
        set { style.paddingBottom = newValue }
    }

    public var paddingLeft: CGFloat? {
        get { return style.paddingLeft }
        set { style.paddingLeft = newValue }
    }

    public var position: NKLayoutPosition? {
        get { return style.position }
        set { style.position = newValue }
    }

    public var width: CGFloat? {
        get { return style.width }
        set { style.width = newValue }
    }

    public var height: CGFloat? {
        get { return style.height }
        set { style.height = newValue }
    }

    public var top: CGFloat? {
        get { return style.top }
        set { style.top = newValue }
    }

    public var right: CGFloat? {
        get { return style.right }
        set { style.right = newValue }
    }

    public var bottom: CGFloat? {
        get { return style.bottom }
        set { style.bottom = newValue }
    }

    public var left: CGFloat? {
        get { return style.left }
        set { style.left = newValue }
    }

    public var expandY: Bool? {
        get { return style.expandY }
        set { style.expandY = newValue }
    }




}
//
//  NKStylesheet.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 27/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public typealias StyleCallback = ((_ builder: NKStyleBuilder) -> ())

open class NKStylesheet: NKStylesheetEntry {
    open static var stylesheet: NKStylesheet?

    public init() {
        super.init(cls: "root")
    }

    public static func styleForClasses(_ classes: [String]) -> NKStyle {
        var classes = classes
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

    open static func styleForView(_ view: AnyClass) -> NKStyle {
        return styleForView(view, classes: [])
    }

    public static func styleForView(_ view: AnyClass, classes: [String]) -> NKStyle {
        var classes = classes
//        Log.t("Getting style for view: \(view)")
        let viewName = NSStringFromClass(view)
//        Log.t("    viewName = \(viewName)")
        let cls = viewName.components(separatedBy: ".").last!
        classes.insert(cls, at: 0)
        return styleForClasses(classes)
    }
}

open class NKStylesheetEntry: CustomDebugStringConvertible {
    let cls: String
    let style: NKStyle
    var childEntries = [NKStylesheetEntry]()

    init(cls: String) {
        self.cls = cls
        self.style = NKStyle()
    }

    open func style(_ cls: String, handler: StyleCallback) {
        let builder = NKStyleBuilder(style: self.style, entry: self)
        builder.style(cls, handler: handler)
    }

    open func style(_ classes: [String], handler: StyleCallback) {
        for cls in classes {
            self.style(cls, handler: handler)
        }
    }

    open var debugDescription: String {
        return "<\(cls) \(childEntries) >"
    }

    func addStylesFromChildEntriesMatching(_ classes: [String], toStyle style: NKStyle) {
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

open class NKStyleBuilder {
    open let style: NKStyle
    let entry: NKStylesheetEntry

    public init(style: NKStyle, entry: NKStylesheetEntry) {
        self.style = style
        self.entry = entry
    }

    open func style(_ cls: String, handler: StyleCallback) {
        let childEntry = NKStylesheetEntry(cls: cls)
        self.entry.childEntries.append(childEntry)

        let builder = NKStyleBuilder(style: childEntry.style, entry: childEntry)
        handler(builder)


    }

    open var opaque: Bool? {
        get { return style.opaque }
        set { style.opaque = newValue }
    }

    open var opacity: CGFloat? {
        get { return style.opacity }
        set { style.opacity = newValue }
    }

    open var backgroundColor: NKColor? {
        get { return style.backgroundColor }
        set { style.backgroundColor = newValue }
    }

    open var background: NKColor? {
        get { return style.background }
        set { style.background = newValue }
    }

    open var textColor: NKColor? {
        get { return style.textColor }
        set { style.textColor = newValue }
    }

    open var textAlign: NKTextAlign? {
        get { return style.textAlign }
        set { style.textAlign = newValue }
    }

    open var image: String? {
        get { return style.image }
        set { style.image = newValue }
    }

    open var fontSize: CGFloat? {
        get { return style.fontSize }
        set { style.fontSize = newValue }
    }

    open var fontWeight: NKFontWeight? {
        get { return style.fontWeight }
        set { style.fontWeight = newValue }
    }

    open var font: XFont? {
        get { return style.font }
        set { style.font = newValue }
    }

    open var border: (CGFloat?, NKColor?) {
        get { return style.border }
        set { style.border = newValue }
    }

    open var borderRadius: CGFloat? {
        get { return style.borderRadius }
        set { style.borderRadius = newValue }
    }

    open var borderTop: (CGFloat?, NKColor?) {
        get { return style.borderTop }
        set { style.borderTop = newValue }
    }

    open var borderRight: (CGFloat?, NKColor?) {
        get { return style.borderRight }
        set { style.borderRight = newValue }
    }

    open var borderBottom: (CGFloat?, NKColor?) {
        get { return style.borderBottom }
        set { style.borderBottom = newValue }
    }

    open var borderLeft: (CGFloat?, NKColor?) {
        get { return style.borderLeft }
        set { style.borderLeft = newValue }
    }

    open var padding: NKPadding {
        get { return style.padding }
        set { style.padding = newValue }
    }

    open var paddingTop: CGFloat? {
        get { return style.paddingTop }
        set { style.paddingTop = newValue }
    }

    open var paddingRight: CGFloat? {
        get { return style.paddingRight }
        set { style.paddingRight = newValue }
    }

    open var paddingBottom: CGFloat? {
        get { return style.paddingBottom }
        set { style.paddingBottom = newValue }
    }

    open var paddingLeft: CGFloat? {
        get { return style.paddingLeft }
        set { style.paddingLeft = newValue }
    }

    open var position: NKLayoutPosition? {
        get { return style.position }
        set { style.position = newValue }
    }

    open var width: CGFloat? {
        get { return style.width }
        set { style.width = newValue }
    }

    open var height: CGFloat? {
        get { return style.height }
        set { style.height = newValue }
    }

    open var top: CGFloat? {
        get { return style.top }
        set { style.top = newValue }
    }

    open var right: CGFloat? {
        get { return style.right }
        set { style.right = newValue }
    }

    open var bottom: CGFloat? {
        get { return style.bottom }
        set { style.bottom = newValue }
    }

    open var left: CGFloat? {
        get { return style.left }
        set { style.left = newValue }
    }

    open var expandY: Bool? {
        get { return style.expandY }
        set { style.expandY = newValue }
    }




}

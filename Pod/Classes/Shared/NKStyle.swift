//
//  NKStyle.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

#if os(OSX)
import AppKit
#endif

enum NKBorderEdge {
    case Top
    case Right
    case Bottom
    case Left
}

class NKBorderEdgeStyle {
    var color: NKColor?
    var width: CGFloat = 1
}

public enum NKTextAlign: String {
    case Left
    case Center
    case Right
}

public enum NKLayoutDirection: String {
    case Vertical
    case Horizontal
}

public enum NKLayoutPosition: String {
    case Absolute
}

enum NKStyleProperty: String {
    case Opacity
    case Opaque

    case BackgroundColor
    case TextColor

    case Image
    
    case FontSize
    case FontWeight
    case FontStyle
    case Font
    case TextAlign
    case TextTransform
    
    case BorderTopColor
    case BorderTopWidth
    case BorderRightColor
    case BorderRightWidth
    case BorderBottomColor
    case BorderBottomWidth
    case BorderLeftColor
    case BorderLeftWidth
    
    case BorderRadiusTopLeft
    case BorderRadiusTopRight
    case BorderRadiusBottomLeft
    case BorderRadiusBottomRight
    
    case PaddingTop
    case PaddingRight
    case PaddingBottom
    case PaddingLeft

    // Just trying something
    case Width
    case Height
    case Top
    case Right
    case Bottom
    case Left

    // Very experimental
    case Layout
    case Position
    case ExpandX
    case CenterX
    case ExpandY
    case CenterY
}


public enum NKFontWeight: String {
    case UltraLight
    case Thin
    case Light
    case Regular
    case Medium
    case Semibold
    case Bold
    case Heavy
    case Black
}

public enum NKTextTransform: String {
    case Uppercase
}

public class NKStyle {
    var properties = [NKStyleProperty: AnyObject]()
    var parentStyle: NKStyle?
    
    // MARK: Lifecycle
    
    convenience init(parent: NKStyle) {
        self.init()
        
        parentStyle = parent
    }
    
    func copy() -> NKStyle {
        return NKStyle(parent: self)
    }

    func mergePropertiesFrom(style otherStyle: NKStyle) {
        for (key, value) in otherStyle.properties {
            properties[key] = value
        }
    }
    
    // MARK: Basic properties

    public var opaque: Bool? {
        get { return getBool(.Opaque) }
        set { properties[.Opaque] = newValue }
    }

    public var opacity: CGFloat? {
        get { return getFloat(.Opacity) }
        set { properties[.Opacity] = newValue }
    }
    
    public var backgroundColor: NKColor? {
        get { return getColor(.BackgroundColor) }
        set { properties[.BackgroundColor] = newValue }
    }
    
    public var background: NKColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    public var textColor: NKColor? {
        get { return getColor(.TextColor) }
        set { properties[.TextColor] = newValue }
    }

    public var image: String? {
        get { return getString(.Image) }
        set { properties[.Image] = newValue }
    }
    
    // MARK: Font properties
    // -----------------------------------------------------------------------
    
    public var fontSize: CGFloat? {
        get { return getFloat(.FontSize) }
        set { set(.FontSize, value: newValue) }
    }
    
    public var fontWeight: NKFontWeight? {
        get {
            if let value = getString(.FontWeight) {
                return NKFontWeight(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.FontWeight, value: newValue?.rawValue)
        }
    }
    
    public var font: XFont? {
        get {
            if let font = properties[.Font] as? XFont {
                return font
            } else {
                let size = fontSize ?? 12
                var weight: CGFloat!

                switch(fontWeight) {
                case .UltraLight?: weight = XFontWeightUltraLight
                case .Thin?: weight = XFontWeightThin
                case .Light?: weight = XFontWeightLight
                case .Regular?: weight = XFontWeightRegular
                case .Medium?: weight = XFontWeightMedium
                case .Semibold?: weight = XFontWeightSemibold
                case .Bold?: weight = XFontWeightBold
                case .Heavy?: weight = XFontWeightHeavy
                case .Black?: weight = XFontWeightBlack
                default: weight = XFontWeightRegular
                }

                return XFont.systemFontOfSize(size, weight: weight)
            }
        }
        set {
            properties[.Font] = newValue
        }
    }

    public var textAlign: NKTextAlign? {
        get {
            if let value = getString(.TextAlign) {
                return NKTextAlign(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.TextAlign, value: newValue?.rawValue)
        }
    }

    public var textTransform: NKTextTransform? {
        get {
            if let value = getString(.TextTransform) {
                return NKTextTransform(rawValue: value)
            } else {
                return nil
            }
        }
        set { set(.TextTransform, value: newValue?.rawValue) }
    }
    
    // MARK: Border properties
    
    public var borderRadius: CGFloat? {
        get {
            let topLeft = getFloat(.BorderRadiusTopLeft)
            let topRight = getFloat(.BorderRadiusTopRight)
            let bottomRight = getFloat(.BorderRadiusBottomRight)
            let bottomLeft = getFloat(.BorderRadiusBottomLeft)

            if topLeft == topRight && topRight == bottomRight && bottomRight == bottomLeft && bottomLeft == topLeft {
                return topLeft
            } else {
                return nil
            }
        }
        set {
            properties[.BorderRadiusTopLeft] = newValue
            properties[.BorderRadiusTopRight] = newValue
            properties[.BorderRadiusBottomLeft] = newValue
            properties[.BorderRadiusBottomRight] = newValue
        }
    }

    var borderRadiusTopLeft: CGFloat? {
        get { return getFloat(.BorderRadiusTopLeft) }
        set { properties[.BorderRadiusTopLeft] = newValue }
    }


    var borderRadiusTopRight: CGFloat? {
        get { return getFloat(.BorderRadiusTopRight) }
        set { properties[.BorderRadiusTopRight] = newValue }
    }


    var borderRadiusBottomRight: CGFloat? {
        get { return getFloat(.BorderRadiusBottomRight) }
        set { properties[.BorderRadiusBottomRight] = newValue }
    }


    var borderRadiusBottomLeft: CGFloat? {
        get { return getFloat(.BorderRadiusBottomLeft) }
        set { properties[.BorderRadiusBottomLeft] = newValue }
    }
    


    var borderRadiuses: (CGFloat?, CGFloat?, CGFloat?, CGFloat?) {
        get {
            return (getFloat(.BorderRadiusTopLeft),
                    getFloat(.BorderRadiusTopRight),
                    getFloat(.BorderRadiusBottomRight),
                    getFloat(.BorderRadiusBottomLeft))
        }
        set {
            let (topLeft, topRight, bottomRight, bottomLeft) = newValue
            properties[.BorderRadiusTopLeft] = topLeft
            properties[.BorderRadiusTopRight] = topRight
            properties[.BorderRadiusBottomRight] = bottomRight
            properties[.BorderRadiusBottomLeft] = bottomLeft
        }
    }

    public var border: (CGFloat?, NKColor?) {
        get {
            return borderTop
        }
        set {
            borderTop = newValue
            borderRight = newValue
            borderBottom = newValue
            borderLeft = newValue
        }
    }

    public var borderWidth: CGFloat? {
        get {
            let (width, _) = border
            return width
        }
        set {
            properties[.BorderTopWidth] = newValue
            properties[.BorderRightWidth] = newValue
            properties[.BorderBottomWidth] = newValue
            properties[.BorderLeftWidth] = newValue
        }
    }

    public var borderColor: NKColor? {
        get {
            let (_, color) = border
            return color
        }
        set {
            properties[.BorderTopColor] = newValue
            properties[.BorderRightColor] = newValue
            properties[.BorderBottomColor] = newValue
            properties[.BorderLeftColor] = newValue
        }
    }
    
    public var borderTop: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderTopWidth), getColor(.BorderTopColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderTopWidth] = width
            properties[.BorderTopColor] = color
        }
    }
    
    public var borderRight: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderRightWidth), getColor(.BorderRightColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderRightWidth] = width
            properties[.BorderRightColor] = color
        }
    }
    
    public var borderBottom: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderBottomWidth), getColor(.BorderBottomColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderBottomWidth] = width
            properties[.BorderBottomColor] = color
        }
    }
    
    public var borderLeft: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderLeftWidth), getColor(.BorderLeftColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderLeftWidth] = width
            properties[.BorderLeftColor] = color
        }
    }
    
    // Padding
    
    public var padding: NKPadding {
        get {
            return NKPadding(
                top: getFloat(.PaddingTop) ?? 0,
                right: getFloat(.PaddingRight) ?? 0,
                bottom: getFloat(.PaddingBottom) ?? 0,
                left: getFloat(.PaddingLeft) ?? 0
            )
        }
        set {
            properties[.PaddingTop] = newValue.top
            properties[.PaddingRight] = newValue.right
            properties[.PaddingBottom] = newValue.bottom
            properties[.PaddingLeft] = newValue.left
        }
    }
    
    public var paddingTop: CGFloat? {
        get { return getFloat(.PaddingTop) }
        set { properties[.PaddingTop] = newValue }
    }
    
    public var paddingRight: CGFloat? {
        get { return getFloat(.PaddingRight) }
        set { properties[.PaddingRight] = newValue }
    }
    
    public var paddingBottom: CGFloat? {
        get { return getFloat(.PaddingBottom) }
        set { properties[.PaddingBottom] = newValue }
    }
    
    public var paddingLeft: CGFloat? {
        get { return getFloat(.PaddingLeft) }
        set { properties[.PaddingLeft] = newValue }
    }

    public var width: CGFloat? {
        get { return getFloat(.Width) }
        set { properties[.Width] = newValue }
    }

    public var height: CGFloat? {
        get { return getFloat(.Height) }
        set { properties[.Height] = newValue }
    }

    public var top: CGFloat? {
        get { return getFloat(.Top) }
        set { properties[.Top] = newValue }
    }

    public var right: CGFloat? {
        get { return getFloat(.Right) }
        set { properties[.Right] = newValue }
    }

    public var bottom: CGFloat? {
        get { return getFloat(.Bottom) }
        set { properties[.Bottom] = newValue }
    }

    public var left: CGFloat? {
        get { return getFloat(.Left) }
        set { properties[.Left] = newValue }
    }

    public var layout: NKLayoutDirection? {
        get {
            if let value = getString(.Layout) {
                return NKLayoutDirection(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.Layout, value: newValue?.rawValue)
        }
    }

    public var position: NKLayoutPosition? {
        get {
            if let value = getString(.Position) {
                return NKLayoutPosition(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.Position, value: newValue?.rawValue)
        }
    }

    public var expandX: Bool? {
        get { return getBool(.ExpandX) ?? false }
        set { properties[.ExpandX] = newValue }
    }

    public var centerX: Bool? {
        get { return getBool(.CenterX) ?? false }
        set { properties[.CenterX] = newValue }
    }

    public var expandY: Bool? {
        get { return getBool(.ExpandY) ?? false }
        set { properties[.ExpandY] = newValue }
    }

    public var centerY: Bool? {
        get { return getBool(.CenterY) ?? false }
        set { properties[.CenterY] = newValue }
    }

    
    // MARK: Accessor functions
    
    func getFloat(property: NKStyleProperty) -> CGFloat? {
        return get(property) as! CGFloat?
    }

    func getBool(property: NKStyleProperty) -> Bool? {
        return get(property) as! Bool?
    }
    
    func getColor(property: NKStyleProperty) -> NKColor? {
        return get(property) as! NKColor?
    }
    
    func getString(property: NKStyleProperty) -> String? {
        return get(property) as! String?
    }
    
    func get(property: NKStyleProperty) -> AnyObject? {
        if let value = properties[property] {
            return value
        } else if let parent = self.parentStyle {
            return parent.get(property)
        } else {
            return nil
        }
    }
    
    func set(property: NKStyleProperty, value: AnyObject?) {
        properties[property] = value
    }
    
    // MARK: Preparing strings
    
    func prepareAttributedString(var text: String) -> NSMutableAttributedString {
        if self.textTransform == .Uppercase {
            text = text.uppercaseString
        }


        let attributed = NSMutableAttributedString(string: text)
        
        attributed.textColor = textColor?.color
        attributed.font = font

        #if os(OSX)
        if let align = self.textAlign {
            let style = NSMutableParagraphStyle()
            switch(align) {
            case .Left:
                style.alignment = .Left
            case .Center:
                style.alignment = .Center
            case .Right:
                style.alignment = .Right
            }

            attributed.style = style
        }
        #endif

        return attributed
    }
    
    // MARK: Drawing

    func draw(rect: CGRect) {
        drawBackground(rect)
        drawBorders(rect)
    }
    
    func drawBackground(rect: CGRect) {
//        let radius = borderRadius ?? 0


        let ctx = XGraphicsGetCurrentContext()
        CGContextSaveGState(ctx)

        let path = pathForBorderRadius(rect)
        CGContextAddPath(ctx, path)
        CGContextClip(ctx)


        if let background = background {
            let colors = (background.colors! as [XColor]).map { $0.CGColor }
            var locations: [CGFloat] = []

            let count = colors.count

            if count == 1 {
                locations.append(0)
            } else {
                for var i = 0; i < count; i++ {
                    locations.append(CGFloat(i) * CGFloat(1/CGFloat(count-1)))
                }
            }


            let space = CGColorSpaceCreateDeviceRGB()

            let gradient = CGGradientCreateWithColors(space, colors, locations)

            let ctx = XGraphicsGetCurrentContext()

            let path = XBezierPath(rect: rect)
            path.addClip()

            var orientation: NKGradientOrientation = .Vertical

            if let gradient = background as? NKGradient {
                orientation = gradient.orientation
            }

            var point2 = CGPointMake(0, rect.size.height)

            if orientation == .Horizontal {
                point2 = CGPointMake(rect.size.width, 0)
            }

            CGContextDrawLinearGradient(ctx, gradient, CGPointMake(0, 0), point2, CGGradientDrawingOptions())

        }

        CGContextRestoreGState(ctx)
    }


    func pathForBorderRadius(rect: CGRect) -> CGPathRef {
        let topLeft = borderRadiusTopLeft ?? 0.0
        let topRight = borderRadiusTopRight ?? 0.0
        let bottomRight = borderRadiusBottomRight ?? 0.0
        let bottomLeft = borderRadiusBottomLeft ?? 0.0

        return NKCreateBorderRadiusPath(rect, topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
    }
    
    func drawBorders(rect: CGRect) {
        if let borderWidth = self.borderWidth, color = self.borderColor where borderRadius > 0 {
            let rect = CGRectInset(rect, borderWidth/2, borderWidth/2)
            let path = pathForBorderRadius(rect)
            let ctx = XGraphicsGetCurrentContext()
            CGContextSaveGState(ctx)
            CGContextAddPath(ctx, path)
            CGContextSetLineWidth(ctx, borderWidth)
            CGContextSetStrokeColorWithColor(ctx, color.CGColor)
            CGContextDrawPath(ctx, .Stroke)
            CGContextRestoreGState(ctx)
        } else {
            self.drawBorder(rect, edge: .Top, color: getColor(.BorderTopColor), width: getFloat(.BorderTopWidth))
            self.drawBorder(rect, edge: .Right, color: getColor(.BorderRightColor), width: getFloat(.BorderRightWidth))
            self.drawBorder(rect, edge: .Bottom, color: getColor(.BorderBottomColor), width: getFloat(.BorderBottomWidth))
            self.drawBorder(rect, edge: .Left, color: getColor(.BorderLeftColor), width: getFloat(.BorderLeftWidth))
        }
    }
    
    func drawBorder(var rect: CGRect, edge: NKBorderEdge, color: NKColor?, width: CGFloat?) {
        if let color = color, let width = width where width > 0 {
            switch(edge) {
            case .Top:
                rect.size.height = width
            case .Right:
                rect.origin.x = rect.size.width - width
                rect.size.width = width
            case .Bottom:
                rect.origin.y = rect.size.height - width
                rect.size.height = width
            case .Left:
                rect.size.width = width
            }
            
            color.set()

            let ctx = XGraphicsGetCurrentContext()
            CGContextFillRect(ctx, rect)
        }
    }
}


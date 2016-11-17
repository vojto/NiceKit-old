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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

#endif

enum NKBorderEdge {
    case top
    case right
    case bottom
    case left
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

open class NKStyle {
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

    open var opaque: Bool? {
        get { return getBool(.Opaque) }
        set { properties[.Opaque] = newValue as AnyObject? }
    }

    open var opacity: CGFloat? {
        get { return getFloat(.Opacity) }
        set { properties[.Opacity] = newValue as AnyObject? }
    }
    
    open var backgroundColor: NKColor? {
        get { return getColor(.BackgroundColor) }
        set { properties[.BackgroundColor] = newValue }
    }
    
    open var background: NKColor? {
        get { return backgroundColor }
        set { backgroundColor = newValue }
    }
    
    open var textColor: NKColor? {
        get { return getColor(.TextColor) }
        set { properties[.TextColor] = newValue }
    }

    open var image: String? {
        get { return getString(.Image) }
        set { properties[.Image] = newValue as AnyObject? }
    }
    
    // MARK: Font properties
    // -----------------------------------------------------------------------
    
    open var fontSize: CGFloat? {
        get { return getFloat(.FontSize) }
        set { set(.FontSize, value: newValue as AnyObject?) }
    }
    
    open var fontWeight: NKFontWeight? {
        get {
            if let value = getString(.FontWeight) {
                return NKFontWeight(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.FontWeight, value: newValue?.rawValue as AnyObject?)
        }
    }
    
    open var font: XFont? {
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

                return XFont.systemFont(ofSize: size, weight: weight)
            }
        }
        set {
            properties[.Font] = newValue
        }
    }

    open var textAlign: NKTextAlign? {
        get {
            if let value = getString(.TextAlign) {
                return NKTextAlign(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.TextAlign, value: newValue?.rawValue as AnyObject?)
        }
    }

    open var textTransform: NKTextTransform? {
        get {
            if let value = getString(.TextTransform) {
                return NKTextTransform(rawValue: value)
            } else {
                return nil
            }
        }
        set { set(.TextTransform, value: newValue?.rawValue as AnyObject?) }
    }
    
    // MARK: Border properties
    
    open var borderRadius: CGFloat? {
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
            properties[.BorderRadiusTopLeft] = newValue as AnyObject?
            properties[.BorderRadiusTopRight] = newValue as AnyObject?
            properties[.BorderRadiusBottomLeft] = newValue as AnyObject?
            properties[.BorderRadiusBottomRight] = newValue as AnyObject?
        }
    }

    var borderRadiusTopLeft: CGFloat? {
        get { return getFloat(.BorderRadiusTopLeft) }
        set { properties[.BorderRadiusTopLeft] = newValue as AnyObject? }
    }


    var borderRadiusTopRight: CGFloat? {
        get { return getFloat(.BorderRadiusTopRight) }
        set { properties[.BorderRadiusTopRight] = newValue as AnyObject? }
    }


    var borderRadiusBottomRight: CGFloat? {
        get { return getFloat(.BorderRadiusBottomRight) }
        set { properties[.BorderRadiusBottomRight] = newValue as AnyObject? }
    }


    var borderRadiusBottomLeft: CGFloat? {
        get { return getFloat(.BorderRadiusBottomLeft) }
        set { properties[.BorderRadiusBottomLeft] = newValue as AnyObject? }
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
            properties[.BorderRadiusTopLeft] = topLeft as AnyObject?
            properties[.BorderRadiusTopRight] = topRight as AnyObject?
            properties[.BorderRadiusBottomRight] = bottomRight as AnyObject?
            properties[.BorderRadiusBottomLeft] = bottomLeft as AnyObject?
        }
    }

    open var border: (CGFloat?, NKColor?) {
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

    open var borderWidth: CGFloat? {
        get {
            let (width, _) = border
            return width
        }
        set {
            properties[.BorderTopWidth] = newValue as AnyObject?
            properties[.BorderRightWidth] = newValue as AnyObject?
            properties[.BorderBottomWidth] = newValue as AnyObject?
            properties[.BorderLeftWidth] = newValue as AnyObject?
        }
    }

    open var borderColor: NKColor? {
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
    
    open var borderTop: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderTopWidth), getColor(.BorderTopColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderTopWidth] = width as AnyObject?
            properties[.BorderTopColor] = color
        }
    }
    
    open var borderRight: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderRightWidth), getColor(.BorderRightColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderRightWidth] = width as AnyObject?
            properties[.BorderRightColor] = color
        }
    }
    
    open var borderBottom: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderBottomWidth), getColor(.BorderBottomColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderBottomWidth] = width as AnyObject?
            properties[.BorderBottomColor] = color
        }
    }
    
    open var borderLeft: (CGFloat?, NKColor?) {
        get { return (getFloat(.BorderLeftWidth), getColor(.BorderLeftColor)) }
        set {
            let (width, color) = newValue
            properties[.BorderLeftWidth] = width as AnyObject?
            properties[.BorderLeftColor] = color
        }
    }
    
    // Padding
    
    open var padding: NKPadding {
        get {
            return NKPadding(
                top: getFloat(.PaddingTop) ?? 0,
                right: getFloat(.PaddingRight) ?? 0,
                bottom: getFloat(.PaddingBottom) ?? 0,
                left: getFloat(.PaddingLeft) ?? 0
            )
        }
        set {
            properties[.PaddingTop] = newValue.top as AnyObject?
            properties[.PaddingRight] = newValue.right as AnyObject?
            properties[.PaddingBottom] = newValue.bottom as AnyObject?
            properties[.PaddingLeft] = newValue.left as AnyObject?
        }
    }
    
    open var paddingTop: CGFloat? {
        get { return getFloat(.PaddingTop) }
        set { properties[.PaddingTop] = newValue as AnyObject? }
    }
    
    open var paddingRight: CGFloat? {
        get { return getFloat(.PaddingRight) }
        set { properties[.PaddingRight] = newValue as AnyObject? }
    }
    
    open var paddingBottom: CGFloat? {
        get { return getFloat(.PaddingBottom) }
        set { properties[.PaddingBottom] = newValue as AnyObject? }
    }
    
    open var paddingLeft: CGFloat? {
        get { return getFloat(.PaddingLeft) }
        set { properties[.PaddingLeft] = newValue as AnyObject? }
    }

    open var width: CGFloat? {
        get { return getFloat(.Width) }
        set { properties[.Width] = newValue as AnyObject? }
    }

    open var height: CGFloat? {
        get { return getFloat(.Height) }
        set { properties[.Height] = newValue as AnyObject? }
    }

    open var top: CGFloat? {
        get { return getFloat(.Top) }
        set { properties[.Top] = newValue as AnyObject? }
    }

    open var right: CGFloat? {
        get { return getFloat(.Right) }
        set { properties[.Right] = newValue as AnyObject? }
    }

    open var bottom: CGFloat? {
        get { return getFloat(.Bottom) }
        set { properties[.Bottom] = newValue as AnyObject? }
    }

    open var left: CGFloat? {
        get { return getFloat(.Left) }
        set { properties[.Left] = newValue as AnyObject? }
    }

    open var layout: NKLayoutDirection? {
        get {
            if let value = getString(.Layout) {
                return NKLayoutDirection(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.Layout, value: newValue?.rawValue as AnyObject?)
        }
    }

    open var position: NKLayoutPosition? {
        get {
            if let value = getString(.Position) {
                return NKLayoutPosition(rawValue: value)
            } else {
                return nil
            }
        }
        set {
            set(.Position, value: newValue?.rawValue as AnyObject?)
        }
    }

    open var expandX: Bool? {
        get { return getBool(.ExpandX) ?? false }
        set { properties[.ExpandX] = newValue as AnyObject? }
    }

    open var centerX: Bool? {
        get { return getBool(.CenterX) ?? false }
        set { properties[.CenterX] = newValue as AnyObject? }
    }

    open var expandY: Bool? {
        get { return getBool(.ExpandY) ?? false }
        set { properties[.ExpandY] = newValue as AnyObject? }
    }

    open var centerY: Bool? {
        get { return getBool(.CenterY) ?? false }
        set { properties[.CenterY] = newValue as AnyObject? }
    }

    
    // MARK: Accessor functions
    
    func getFloat(_ property: NKStyleProperty) -> CGFloat? {
        return get(property) as! CGFloat?
    }

    func getBool(_ property: NKStyleProperty) -> Bool? {
        return get(property) as! Bool?
    }
    
    func getColor(_ property: NKStyleProperty) -> NKColor? {
        return get(property) as! NKColor?
    }
    
    func getString(_ property: NKStyleProperty) -> String? {
        return get(property) as! String?
    }
    
    func get(_ property: NKStyleProperty) -> AnyObject? {
        if let value = properties[property] {
            return value
        } else if let parent = self.parentStyle {
            return parent.get(property)
        } else {
            return nil
        }
    }
    
    func set(_ property: NKStyleProperty, value: AnyObject?) {
        properties[property] = value
    }
    
    // MARK: Preparing strings
    
    func prepareAttributedString(_ text: String) -> NSMutableAttributedString {
        var text = text
        if self.textTransform == .Uppercase {
            text = text.uppercased()
        }


        let attributed = NSMutableAttributedString(string: text)
        
        attributed.textColor = textColor?.color
        attributed.font = font

        #if os(OSX)
        if let align = self.textAlign {
            let style = NSMutableParagraphStyle()
            switch(align) {
            case .Left:
                style.alignment = .left
            case .Center:
                style.alignment = .center
            case .Right:
                style.alignment = .right
            }

            attributed.style = style
        }
        #endif

        return attributed
    }
    
    // MARK: Drawing

    func draw(_ rect: CGRect) {
        drawBackground(rect)
        drawBorders(rect)
    }
    
    func drawBackground(_ rect: CGRect) {
//        let radius = borderRadius ?? 0


        let ctx = XGraphicsGetCurrentContext()
        ctx.saveGState()

        let path = pathForBorderRadius(rect)
        ctx.addPath(path)
        ctx.clip()


        if let background = background {
            let colors = (background.colors! as [XColor]).map { $0.cgColor }
            var locations: [CGFloat] = []

            let count = colors.count

            if count == 1 {
                locations.append(0)
            } else {
                for i in 0 ..< count {
                    locations.append(CGFloat(i) * CGFloat(1/CGFloat(count-1)))
                }
            }


            let space = CGColorSpaceCreateDeviceRGB()

            let gradient = CGGradient(colorsSpace: space, colors: colors as CFArray, locations: locations)

            let ctx = XGraphicsGetCurrentContext()

            let path = XBezierPath(rect: rect)
            path.addClip()

            var orientation: NKGradientOrientation = .vertical

            if let gradient = background as? NKGradient {
                orientation = gradient.orientation
            }

            var point2 = CGPoint(x: 0, y: rect.size.height)

            if orientation == .horizontal {
                point2 = CGPoint(x: rect.size.width, y: 0)
            }

            ctx.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: point2, options: CGGradientDrawingOptions())

        }

        ctx.restoreGState()
    }


    func pathForBorderRadius(_ rect: CGRect) -> CGPath {
        let topLeft = borderRadiusTopLeft ?? 0.0
        let topRight = borderRadiusTopRight ?? 0.0
        let bottomRight = borderRadiusBottomRight ?? 0.0
        let bottomLeft = borderRadiusBottomLeft ?? 0.0

        return NKCreateBorderRadiusPath(rect, topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
    }
    
    func drawBorders(_ rect: CGRect) {
        if let borderWidth = self.borderWidth, let color = self.borderColor , borderRadius > 0 {
            let rect = rect.insetBy(dx: borderWidth/2, dy: borderWidth/2)
            let path = pathForBorderRadius(rect)
            let ctx = XGraphicsGetCurrentContext()
            ctx.saveGState()
            ctx.addPath(path)
            ctx.setLineWidth(borderWidth)
            ctx.setStrokeColor(color.CGColor)
            ctx.drawPath(using: .stroke)
            ctx.restoreGState()
        } else {
            self.drawBorder(rect, edge: .top, color: getColor(.BorderTopColor), width: getFloat(.BorderTopWidth))
            self.drawBorder(rect, edge: .right, color: getColor(.BorderRightColor), width: getFloat(.BorderRightWidth))
            self.drawBorder(rect, edge: .bottom, color: getColor(.BorderBottomColor), width: getFloat(.BorderBottomWidth))
            self.drawBorder(rect, edge: .left, color: getColor(.BorderLeftColor), width: getFloat(.BorderLeftWidth))
        }
    }
    
    func drawBorder(_ rect: CGRect, edge: NKBorderEdge, color: NKColor?, width: CGFloat?) {
        var rect = rect
        if let color = color, let width = width , width > 0 {
            switch(edge) {
            case .top:
                rect.size.height = width
            case .right:
                rect.origin.x = rect.size.width - width
                rect.size.width = width
            case .bottom:
                rect.origin.y = rect.size.height - width
                rect.size.height = width
            case .left:
                rect.size.width = width
            }
            
            color.set()

            let ctx = XGraphicsGetCurrentContext()
            ctx.fill(rect)
        }
    }
}


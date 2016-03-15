
//
//  NKButton.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

public class NKButton: NKView {

    // MARK: - Properties
    // -----------------------------------------------------------------------

    public var image: XImage?

    public var imageEdgeInsets: XEdgeInsets?
    public var imageEdgeInsetsNormalized: XEdgeInsets {
        let insets = imageEdgeInsets ?? XEdgeInsetsZero
        return XEdgeInsets(top: insets.top/2, left: insets.left/2, bottom: insets.bottom/2, right: insets.right/2)
    }

    public var title: String! = ""

    public var leftClickShowsMenu = false

    public var enabled = true {
        didSet {
            if enabled {
                removeClass("disabled")
            } else {
                addClass("disabled")
            }

            applyStyle()
        }
    }

    public var imageSize: CGSize { return image?.size ?? CGSizeMake(0, 0) }

    public var imageOuterSize: CGSize {
        let insets = imageEdgeInsetsNormalized

        return CGSizeMake(imageSize.width + insets.left + insets.right,
            imageSize.height + insets.top + insets.bottom)
    }

    // MARK: - Lifecycle
    // -----------------------------------------------------------------------

    public convenience init(title: String) {
        self.init()
        self.title = title
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    required public init() {
        super.init()

        shouldTrackMouseEnterExit = true
    }

    // MARK: - Applying style
    // -----------------------------------------------------------------------

    public override func applyStyle() {
        if let image = style.image {
            self.image = NSImage(named: image)
        }

        super.applyStyle()
    }

    // MARK: - Drawing
    // -----------------------------------------------------------------------

    override public func drawRect(dirtyRect: CGRect) {
        super.drawRect(dirtyRect)

        let size = intrinsicContentSize

        let ctx = XGraphicsGetCurrentContext()

        NKColor.yellow().set()
//        CGContextFillRect(ctx, bounds)


        let x = (bounds.size.width - size.width)/2
        let y = (bounds.size.height - size.height)/2

        let rect = CGRectMake(x, y, size.width, size.height)

        let imageRect = CGRectMake(x, y + (size.height - imageOuterSize.height)/2, imageOuterSize.width, imageOuterSize.height)
        let textRect = CGRectMake(x + imageOuterSize.width, y, size.width - imageOuterSize.width, size.height)



        XColor.blackColor().set()

        //            CGContextFillRect(ctx, rect)

        self.drawTitle(textRect)


        XColor.blueColor().set()
        //            CGContextFillRect(ctx, imageRect)

        self.drawImage(imageRect)
    }

    func drawTitle(rect: CGRect) {

        // Draw a background so we could see where are we drawing the title
//        let ctx = XGraphicsGetCurrentContext()
//        NKColor.green().set()
//        CGContextFillRect(ctx, rect)

        let title = style.prepareAttributedString(self.title)

        //            let fontSize = self.intrinsicTextSize.height
        //            let height = rect.size.height
        //            let top = (height - fontSize) / 2

//        title.drawAtPoint(CGPointMake(rect.origin.x, rect.origin.y))
        title.drawInRect(rect)
    }

    func drawImage(rect: CGRect) {
        let insets = imageEdgeInsetsNormalized

        let drawRect = CGRectMake(rect.origin.x + insets.left,
            rect.origin.y + insets.bottom,
            imageSize.width,
            imageSize.height)

        if self.image == nil {
            return
        }

        let image = self.image!

        // Vertically center the image
        //            rect.origin.y = (self.bounds.size.height - rect.height) / 2 - 1

        if let color = style.textColor {
            image.draw(color.color, drawRect: drawRect)
        } else {
            image.drawInRect(drawRect)
        }


    }

    // MARK: - Sizing
    // -----------------------------------------------------------------------

    var intrinsicTextSize: CGSize {
        if let title = title {
            let attributed = style.prepareAttributedString(title)
            let boundingRect = style.font!.boundingRectForFont
            let fontHeight = ceil(boundingRect.size.height)
            let size = attributed.size()

            //                return size

            return CGSizeMake(size.width, fontHeight)

            //                return size
        } else {
            return CGSizeZero
        }
    }

    func getIntrinsicContentSize() -> CGSize {
        var size = intrinsicTextSize
        size.width += style.padding.horizontal
        size.height += style.padding.vertical

        size.width += imageOuterSize.width

        if imageOuterSize.height > size.height {
            size.height = imageOuterSize.height
        }

        return size
    }


    override public var intrinsicContentSize: CGSize {
        get { return getIntrinsicContentSize() }
    }

    override public var baselineOffsetFromBottom: CGFloat {
        let font = style.font!
        let boundingRect = style.font!.boundingRectForFont
        return floor(abs(font.descender) + abs(boundingRect.origin.y)/2)
    }

    // MARK: - Event handling
    // -----------------------------------------------------------------------

    override public func mouseDown(theEvent: NSEvent) {
        addClass("active")
        setNeedsDisplay()

        if let menu = menu where leftClickShowsMenu {
            let item = menu.itemArray.first
            menu.popUpMenuPositioningItem(item, atLocation: NSMakePoint(15, -5), inView: self)
        }
    }

    override public func mouseUp(theEvent: NSEvent) {
        removeClass("active")
        setNeedsDisplay()

        if enabled {
            onClick?()
        }
    }

    override public var mouseDownCanMoveWindow: Bool {
        return false
    }
}
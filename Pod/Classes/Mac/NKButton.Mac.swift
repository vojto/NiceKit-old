
//
//  NKButton.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit

open class NKButton: NKView {
    
    // MARK: - Properties
    // -----------------------------------------------------------------------
    
    open var image: XImage?
    
    open var imageEdgeInsets: XEdgeInsets?
    open var imageEdgeInsetsNormalized: XEdgeInsets {
        let insets = imageEdgeInsets ?? XEdgeInsetsZero
        return XEdgeInsets(top: insets.top/2, left: insets.left/2, bottom: insets.bottom/2, right: insets.right/2)
    }
    
    open var title: String! = ""
    
    open var leftClickShowsMenu = false
    
    open var enabled = true {
        didSet {
            if enabled {
                removeClass("disabled")
            } else {
                addClass("disabled")
            }
            
            applyStyle()
        }
    }
    
    open var imageSize: CGSize { return image?.size ?? CGSize(width: 0, height: 0) }
    
    open var imageOuterSize: CGSize {
        let insets = imageEdgeInsetsNormalized
        
        return CGSize(width: imageSize.width + insets.left + insets.right,
                      height: imageSize.height + insets.top + insets.bottom)
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
    
    open override func applyStyle() {
        if let image = style.image {
            self.image = NSImage(named: image)
        }
        
        super.applyStyle()
    }
    
    // MARK: - Drawing
    // -----------------------------------------------------------------------
    
    override open func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        
        let size = intrinsicContentSize
        
        _ = XGraphicsGetCurrentContext()
        
        NKColor.yellow().set()
        //        CGContextFillRect(ctx, bounds)
        
        
        let x = (bounds.size.width - size.width)/2
        let y = (bounds.size.height - size.height)/2
        
        _ = CGRect(x: x, y: y, width: size.width, height: size.height)
        
        let imageRect = CGRect(x: x, y: y + (size.height - imageOuterSize.height)/2, width: imageOuterSize.width, height: imageOuterSize.height)
        let textRect = CGRect(x: x + imageOuterSize.width, y: y, width: size.width - imageOuterSize.width, height: size.height)
        
        
        
        XColor.black.set()
        
        //            CGContextFillRect(ctx, rect)
        
        self.drawTitle(textRect)
        
        
        XColor.blue.set()
        //            CGContextFillRect(ctx, imageRect)
        
        self.drawImage(imageRect)
    }
    
    func drawTitle(_ rect: CGRect) {
        
        // Draw a background so we could see where are we drawing the title
        //        let ctx = XGraphicsGetCurrentContext()
        //        NKColor.green().set()
        //        CGContextFillRect(ctx, rect)
        
        let title = style.prepareAttributedString(self.title)
        
        //            let fontSize = self.intrinsicTextSize.height
        //            let height = rect.size.height
        //            let top = (height - fontSize) / 2
        
        //        title.drawAtPoint(CGPointMake(rect.origin.x, rect.origin.y))
        title.draw(in: rect)
    }
    
    func drawImage(_ rect: CGRect) {
        let insets = imageEdgeInsetsNormalized
        
        let drawRect = CGRect(x: rect.origin.x + insets.left,
                              y: rect.origin.y + insets.bottom,
                              width: imageSize.width,
                              height: imageSize.height)
        
        if self.image == nil {
            return
        }
        
        let image = self.image!
        
        // Vertically center the image
        //            rect.origin.y = (self.bounds.size.height - rect.height) / 2 - 1
        
        if let color = style.textColor {
            image.draw(color.color, drawRect: drawRect, flip: true)
        } else {
            image.draw(in: drawRect)
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
            
            return CGSize(width: size.width, height: fontHeight)
            
            //                return size
        } else {
            return CGSize.zero
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
    
    
    override open var intrinsicContentSize: CGSize {
        get { return getIntrinsicContentSize() }
    }
    
    override open var baselineOffsetFromBottom: CGFloat {
        let font = style.font!
        let boundingRect = style.font!.boundingRectForFont
        return floor(abs(font.descender) + abs(boundingRect.origin.y)/2)
    }
    
    // MARK: - Event handling
    // -----------------------------------------------------------------------
    
    override open func mouseDown(with theEvent: NSEvent) {
        addClass("active")
        setNeedsDisplay()
        
        if let menu = menu , leftClickShowsMenu {
            let item = menu.items.first
            menu.popUp(positioning: item, at: NSMakePoint(15, -5), in: self)
        }
    }
    
    override open func mouseUp(with theEvent: NSEvent) {
        removeClass("active")
        setNeedsDisplay()
        
        if enabled {
            onClick?()
        }
    }
    
    override open var mouseDownCanMoveWindow: Bool {
        return false
    }
}

//
//  NKViewable.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 27/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cartography

public protocol NKViewable: class {
    var style: NKStyle { get set }
    var classes: Set<String> { get set }

    func setup()
//
    func addClass(cls: String)
    func removeClass(cls: String)

    func applyStyle()

    var onMouseDown: (XEvent -> Void)? { get set }
}



extension NKViewable {
    public var onMouseDown: (XEvent -> Void)? {
        get { return nil }
        set { }
    }

    public func addClass(cls: String) {
        self.classes.insert(cls)
        self.updateStyle()
    }

    public func removeClass(cls: String) {
        self.classes.remove(cls)
        self.updateStyle()
    }

    func updateStyle() {
        self.style = NKStylesheet.styleForView(self.dynamicType, classes: Array(self.classes))
        self.applyStyle()
    }

    public func applyStyle() {
    }

    public func addSubviews(views: [XView]) {
        let parentView = self as! XView
        for view in views {
            parentView.addSubview(view)
        }
    }

    func applyLayoutFromChildrenStyles() {
        // First apply our own style to the layout

        let parentLayout = style.layout

        let subviews = (self as! XView).subviews

        let views = subviews.filter { $0 is NKViewable }.map { $0 as! NKViewable }


        for var i = 0; i < views.count; i++ {
            let subview = views[i]
            let style = subview.style

            // Width & height
            if let width = style.width {
                constrain(subview as! XView) { s in s.width == width }
            }

            if let height = style.height {
                constrain(subview as! XView) { s in s.height == height }
            }

            if style.expandX == true {
                subview.expandX()
            }

            if style.centerX == true {
                subview.centerX()
            }

            if style.expandY == true {
                subview.expandY()
            }

            if style.centerY == true {
                subview.centerY()
            }

            if subview.style.position == .Absolute {
                if let top = subview.style.top {
                    constrain(subview as! XView) { s in s.top == s.superview!.top + top }
                }

                if let right = subview.style.right {
                    constrain(subview as! XView) { s in s.right == s.superview!.right - right }
                }

                if let bottom = subview.style.bottom {
                    constrain(subview as! XView) { s in s.bottom == s.superview!.bottom - bottom }
                }

                if let left = subview.style.left {
                    constrain(subview as! XView) { s in s.left == s.superview!.left + left }
                }

                continue
            }

            if parentLayout == .Vertical {
                // User left/right to pin to sides. Do it if left is explicitly
                // defined, and pin it anyway to the left, but only in case there
                // isn't any centerX or expandX flag.
                if let left = style.left {
                    let group = constrain(subview as! XView) { s in s.left == s.superview!.left + left }

                } else if (style.centerX != true && style.expandX != true) {
                    constrain(subview as! XView) { s in s.left == s.superview!.left }
                }

                if let right = style.right {
                    constrain(subview as! XView) { s in s.right == s.superview!.right - right }
                }

                let previous = previousBlockPositionedView(views, index: i) as! XView?
                let next = nextBlockPositionedView(views, index: i) as! XView?

                // If this is the first view, pin top to superview
                if previous == nil {
                    let top = style.top ?? 0
                    constrain(subview as! XView) { s in s.top == s.superview!.top + top }
                }

                // Figure out distance between current view and the next view
                if let next = next {
                    let bottom = style.bottom ?? 0
                    let top = (next as! NKViewable).style.top ?? 0

                    let distance = bottom > top ? bottom : top

                    constrain(subview as! XView, next) { s, n in s.bottom == n.top - distance }
                }

                // If this is the last view, pin to bottom, but only if explicitly
                // defined so using current.bottom
                if let bottom = style.bottom where next == nil {
                    constrain(subview as! XView) { s in s.bottom == s.superview!.bottom - bottom }
                }

            } else if parentLayout == .Horizontal {
                if let top = style.top {
                    constrain(subview as! XView) { s in s.top == s.superview!.top + top }
                } else if (style.centerY != true && style.expandY != true) {
                    constrain(subview as! XView) { s in s.top == s.superview!.top }
                }

                if let bottom = style.bottom {
                    constrain(subview as! XView) { s in s.bottom == s.superview!.bottom - bottom }
                }

                let previous = previousBlockPositionedView(views, index: i) as! XView?
                let next = nextBlockPositionedView(views, index: i) as! XView?

                // If this is the first view, pin top to superview
                if previous == nil {
                    let left = style.left ?? 0
                    constrain(subview as! XView) { s in s.left == s.superview!.left + left }
                }

                // Figure out distance between current view and the next view
                if let next = next {
                    let right = style.right ?? 0
                    let left = (next as! NKViewable).style.left ?? 0

                    let distance = right > left ? right : left

                    constrain(subview as! XView, next) { s, n in s.right == n.left - distance }
                }
                
                if let right = style.right where next == nil {
                    constrain(subview as! XView) { s in s.right == s.superview!.right - right }
                }
            }
        }
    }

    func nextBlockPositionedView(views: [NKViewable], var index: Int) -> NKViewable? {
        while let view = views.get(++index) {
            if view.style.position == nil {
                return view
            }
        }

        return nil
    }

    func previousBlockPositionedView(views: [NKViewable], var index: Int) -> NKViewable? {
        while let view = views.get(--index) {
            if view.style.position == nil {
                return view
            }
        }

        return nil
    }
}

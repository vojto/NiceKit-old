//
//  NKView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 03/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Cartography

public typealias SetupCallback = ((view: NKViewable) -> ([NKViewable]))


public class NKView: XView, NKViewable {

    // MARK: - Properties
    // -----------------------------------------------------------------------

    public var style: NKStyle
    public var classes = Set<String>()

    // MARK: - Lifecycle
    // -----------------------------------------------------------------------

    required public init() {
        style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: CGRectZero)

//        self.opaque = false

        setup()

        applyLayoutFromChildrenStyles()
        postSetup()
    }

    public init(setup: SetupCallback) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(frame: CGRectZero)

        let subviews = setup(view: self).map { $0 as! XView }
        addSubviews(subviews)

        applyLayoutFromChildrenStyles()
        postSetup()
    }

    required public init?(coder: NSCoder) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(coder: coder)
    }

    public func setup() {}

    func postSetup() {}
    
    func unsetup() {}

    public func setContext(context: AnyObject?) {}

    public override func layoutSubviews() {
        super.layoutSubviews()
        
        applyStyle()
    }

    public func applyStyle() {
        #if os(iOS)
        if let opaque = style.opaque {
            self.opaque = opaque
        }
        #endif

        if let opacity = style.opacity {
            self.alpha = opacity
        } else {
            self.alpha = 1
        }


        setNeedsDisplay()
    }

    // Drawing
    // -----------------------------------------------------------------------

    override public func drawRect(dirtyRect: CGRect) {
        style.draw(bounds)
    }

    // OS X specific
    // -----------------------------------------------------------------------

#if os(OSX)
    public var onTap: (() -> ())?
    public var onClick: NKSimpleCallback?
    public var action: NKSimpleCallback? {
        get { return onClick }
        set { onClick = newValue }
    }

    public var mouseTrackingArea: NSTrackingArea?
    public var clipsToBounds = false

    public func preferredStatusBarStyle() -> XStatusBarStyle {
        return .Default
    }

    public var userInteractionEnabled = true

    public var transform: CGAffineTransform? // TODO: Implement

    public func setNeedsDisplay() {
        self.setNeedsDisplayInRect(self.bounds)
    }

    public var shouldTrackMouseEnterExit = false

    override public var flipped: Bool { return true }

    override public func updateTrackingAreas() {
        if let area = self.mouseTrackingArea {
            self.removeTrackingArea(area)
        }
        if self.shouldTrackMouseEnterExit {
            self.mouseTrackingArea = NSTrackingArea(rect: self.bounds, options: [.ActiveAlways, .MouseEnteredAndExited], owner: self, userInfo: nil)

            self.addTrackingArea(self.mouseTrackingArea!)
        }
    }

    override public func mouseEntered(theEvent: XEvent) {
        addClass("hover")
    }

    override public func mouseExited(theEvent: XEvent) {
        removeClass("hover")
    }

    override public func mouseDown(theEvent: NSEvent) {
        if onClick == nil {
            super.mouseDown(theEvent)
        }
    }

    override public func mouseUp(theEvent: NSEvent) {
        if onClick == nil {
            super.mouseUp(theEvent)
        } else {
            onClick?()
        }
    }

    func setOpaque(opauqe: Bool) {
        // Doesn't do anything on Mac
    }

#endif


    // MARK: iOS specific
    // -----------------------------------------------------------------------

#if os(iOS)
    var tapRecognizer: UITapGestureRecognizer?
    var onClick: NKSimpleCallback?
    var onTap: NKSimpleCallback? {
        didSet {
            if tapRecognizer == nil {
                tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
                addGestureRecognizer(tapRecognizer!)
            }
        }
    }

    func handleTap() {
        onTap?()
    }

    func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

//    func setOpaque(opauqe: Bool) {
//        self.opauqe = opaque
//    }

    #else
#endif
}


func alignVertically(items: [LayoutProxy], margin: CGFloat) {
    for var i = 1; i < items.count; i++ {
        items[i].top == items[i-1].bottom + margin
    }
}

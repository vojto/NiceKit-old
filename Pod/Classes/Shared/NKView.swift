//
//  NKView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 03/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Cartography

public typealias SetupCallback = ((_ view: NKViewable) -> ([NKViewable]))


open class NKView: XView, NKViewable {

    // MARK: - Properties
    // -----------------------------------------------------------------------

    open var style: NKStyle
    open var classes = Set<String>()

    // MARK: - Lifecycle
    // -----------------------------------------------------------------------

    required public init() {
        style = NKStylesheet.styleForView(type(of: self))

        super.init(frame: CGRect.zero)

//        self.opaque = false

        setup()

        applyLayoutFromChildrenStyles()
        postSetup()
    }

    public init(setup: SetupCallback) {
        self.style = NKStylesheet.styleForView(type(of: self))

        super.init(frame: CGRect.zero)

        self.setup()

        let subviews = setup(self).map { $0 as! XView }
        addSubviews(subviews)

        applyLayoutFromChildrenStyles()
        postSetup()
    }

    required public init?(coder: NSCoder) {
        self.style = NKStylesheet.styleForView(type(of: self))

        super.init(coder: coder)
    }

    open func setup() {}

    func postSetup() {}
    
    func unsetup() {}

    open func setContext(_ context: AnyObject?) {}

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        applyStyle()
    }

    open func applyStyle() {
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

    override open func draw(_ dirtyRect: CGRect) {
        style.draw(bounds)
    }

    // OS X specific
    // -----------------------------------------------------------------------

#if os(OSX)
    open var onTap: NKSimpleCallback?
    open var onTouchDown: NKSimpleCallback?
    open var onClick: NKSimpleCallback?
    open var action: NKSimpleCallback? {
        get { return onClick }
        set { onClick = newValue }
    }
    open var onMouseOver: NKSimpleCallback?
    open var onMouseOut: NKSimpleCallback?

    open var mouseTrackingArea: NSTrackingArea?
    open var clipsToBounds = false

    open func preferredStatusBarStyle() -> XStatusBarStyle {
        return .default
    }

    open var userInteractionEnabled = true

    open var transform: CGAffineTransform? // TODO: Implement

    open func setNeedsDisplay() {
        self.setNeedsDisplay(self.bounds)
    }

    open var shouldTrackMouseEnterExit = false

    override open var isFlipped: Bool { return true }

    override open func updateTrackingAreas() {
        if let area = self.mouseTrackingArea {
            self.removeTrackingArea(area)
        }
        if self.shouldTrackMouseEnterExit {
            self.mouseTrackingArea = NSTrackingArea(rect: self.bounds, options: [.activeAlways, .mouseEnteredAndExited], owner: self, userInfo: nil)

            self.addTrackingArea(self.mouseTrackingArea!)
        }
    }

    override open func mouseEntered(with theEvent: XEvent) {
        onMouseOver?()
        addClass("hover")
    }

    override open func mouseExited(with theEvent: XEvent) {
        onMouseOut?()
        removeClass("hover")
    }

    override open func mouseDown(with theEvent: NSEvent) {
        if onClick == nil {
            super.mouseDown(with: theEvent)
        }
    }

    override open func mouseUp(with theEvent: NSEvent) {
        if onClick == nil {
            super.mouseUp(with: theEvent)
        } else {
            onClick?()
        }
    }

    func setOpaque(_ opauqe: Bool) {
        // Doesn't do anything on Mac
    }

#endif


    // MARK: iOS specific
    // -----------------------------------------------------------------------

#if os(iOS)
    public var tapRecognizer: UITapGestureRecognizer?
    public var onClick: NKSimpleCallback?
    public var onTap: NKSimpleCallback? {
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

    public func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

//    func setOpaque(opauqe: Bool) {
//        self.opauqe = opaque
//    }

    #else
#endif
}


func alignVertically(_ items: [LayoutProxy], margin: CGFloat) {
    for i in 1 ..< items.count {
        items[i].top == items[i-1].bottom + margin
    }
}

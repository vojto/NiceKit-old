//
//  NKWindow.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 03/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Cocoa

public enum NKWindowOpeningPolicy: String {
    case Default
    case Sheet
}

open class NKWindow: NSWindow {

    open var openingPolicy: NKWindowOpeningPolicy = .Default
    open var sheetOffset: NSSize?

    // Properties
    // -----------------------------------------------------------------------



    var navigationStack = [NKView]()
    var canNavigateBack: Bool { return executedTransitions.count > 1 }
    var executedTransitions = Array<NKTransition>()
    
    var handleZoom: (() -> ())?
    var closeButton: NSButton? { get { return self.standardWindowButton(.closeButton) } }
    var miniaturizeButton: NSButton? { get { return self.standardWindowButton(.miniaturizeButton) } }
    var zoomButton: NSButton? { get { return self.standardWindowButton(.zoomButton) } }

    open var currentScene: String? {
        return executedTransitions.last?.toScene
    }


    // Lifecycle
    // -----------------------------------------------------------------------


    public override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: NSWindowStyleMask(rawValue: UInt(aStyle)), backing: bufferingType, defer: flag)

        self.showsResizeIndicator = true

        NotificationCenter.default.addObserver(self, selector: #selector(NKWindow.willClose(_:)), name: NSNotification.Name.NSWindowWillClose, object: self)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func willClose(_ notification: Notification) {
        let storyboard = NKStoryboard.instance

        if storyboard.mainWindow != self {
            self.popAllTransitions()
        }
    }




    // Controlling the look of the window
    // -----------------------------------------------------------------------
    
    func hideButtons() {
        // Hide standard buttons
        self.closeButton?.isHidden = true
        self.miniaturizeButton?.isHidden = true
        self.zoomButton?.isHidden = true
    }

    open func setupCustomHeader() {
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isMovableByWindowBackground = true
    }



    // Actions
    // -----------------------------------------------------------------------
    
    override open func zoom(_ sender: Any?) {
        if let fun = self.handleZoom {
            fun()
        } else {
            super.zoom(sender)
        }
    }



    // Presenting sheet window
    // -----------------------------------------------------------------------

    var sheetWindow: NKSheetWindow?
    func presentSheet(_ view: NKView, size: CGSize) {
        if sheetWindow == nil {
            sheetWindow = NKSheetWindow(contentRect: CGRect(x: 0, y: 0, width: size.width, height: size.height), styleMask: NSTitledWindowMask, backing: .buffered, defer: false)
        }

        sheetWindow!.contentView = view

        beginSheet(sheetWindow!) { _ in
        }
    }

    func closeSheet() {
        endSheet(sheetWindow!)
    }




    // Executing storyboard transitions
    // -----------------------------------------------------------------------

    func transitionTo(_ scene: NKScene, context: AnyObject?) {
        if currentScene == scene.name {
            return
        }

        let storyboard = NKStoryboard.instance
        guard let transition = storyboard.findTransition(scene.windowName, fromScene: currentScene, toScene: scene.name) else {
            fatalError("No transition from \(currentScene) to \(scene.name)")
        }

        let view = storyboard.viewFor(scene)

        if let context = context {
            view.setContext(context)
        }

        switch(transition.transition) {
        case .None:
            contentView!.addSubview(view)
            view.expand()
            navigationStack.append(view)
        case .Push:
            self.push(view)
        default:
            fatalError("Cannot execute transition type \(transition.transition)")
            break
        }

        executedTransitions.append(transition)
    }

    func transitionBack() {
        let transition = executedTransitions.removeLast()

        switch(transition.transition) {
        case .Push:
            self.pop()
        case .None:
            let view = navigationStack.last!
            view.removeFromSuperview()
        default:
            fatalError("Cannot transition back from transition with type \(transition.transition)")
            break
        }
    }

    func popAllTransitions() {
        executedTransitions.removeAll()
        navigationStack.removeAll()
        for subview in contentView!.subviews {
            subview.removeFromSuperview()
        }
    }




    // Managing the navigation stack
    // -----------------------------------------------------------------------

    func push(_ view: NKView) {
        let currentView = contentView!.subviews[0]

        view.frame = contentView!.frame

        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight

        contentView!.animations = ["subviews": transition]

        contentView!.animator().replaceSubview(currentView, with: view)

        view.expand()

        navigationStack.append(view)
    }

    func pop() {
        let view = navigationStack.removeLast()
        let previous = navigationStack.last!

        previous.frame = contentView!.frame

        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft

        contentView!.animations = ["subviews": transition]

        contentView!.animator().replaceSubview(view, with: previous)
        
        previous.expand()
    }




}

class NKSheetWindow: NSWindow {

}



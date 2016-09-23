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

public class NKWindow: NSWindow {

    public var openingPolicy: NKWindowOpeningPolicy = .Default
    public var sheetOffset: NSSize?

    // Properties
    // -----------------------------------------------------------------------



    var navigationStack = [NKView]()
    var canNavigateBack: Bool { return executedTransitions.count > 1 }
    var executedTransitions = Array<NKTransition>()
    
    var handleZoom: (() -> ())?
    var closeButton: NSButton? { get { return self.standardWindowButton(.CloseButton) } }
    var miniaturizeButton: NSButton? { get { return self.standardWindowButton(.MiniaturizeButton) } }
    var zoomButton: NSButton? { get { return self.standardWindowButton(.ZoomButton) } }

    public var currentScene: String? {
        return executedTransitions.last?.toScene
    }


    // Lifecycle
    // -----------------------------------------------------------------------


    public override init(contentRect: NSRect, styleMask aStyle: Int, backing bufferingType: NSBackingStoreType, `defer` flag: Bool) {
        super.init(contentRect: contentRect, styleMask: aStyle, backing: bufferingType, `defer`: flag)

        self.showsResizeIndicator = true

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "willClose:", name: NSWindowWillCloseNotification, object: self)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func willClose(notification: NSNotification) {
        let storyboard = NKStoryboard.instance

        if storyboard.mainWindow != self {
            self.popAllTransitions()
        }
    }




    // Controlling the look of the window
    // -----------------------------------------------------------------------
    
    func hideButtons() {
        // Hide standard buttons
        self.closeButton?.hidden = true
        self.miniaturizeButton?.hidden = true
        self.zoomButton?.hidden = true
    }

    public func setupCustomHeader() {
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .Hidden
        self.movableByWindowBackground = true
    }



    // Actions
    // -----------------------------------------------------------------------
    
    override public func zoom(sender: AnyObject?) {
        if let fun = self.handleZoom {
            fun()
        } else {
            super.zoom(sender)
        }
    }



    // Presenting sheet window
    // -----------------------------------------------------------------------

    var sheetWindow: NKSheetWindow?
    func presentSheet(view: NKView, size: CGSize) {
        if sheetWindow == nil {
            sheetWindow = NKSheetWindow(contentRect: CGRectMake(0, 0, size.width, size.height), styleMask: NSTitledWindowMask, backing: .Buffered, `defer`: false)
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

    func transitionTo(scene: NKScene, context: AnyObject?) {
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

    func push(view: NKView) {
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



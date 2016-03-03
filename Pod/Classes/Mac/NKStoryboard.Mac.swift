//
//  NKStoryboard.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 11/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import QuartzCore
import AppKit


struct NKScene: Hashable {
    let windowName: String
    let name: String
    let viewClass: NKView.Type

    var hashValue: Int {
        return "\(windowName)\(name)".hashValue
    }
}

func ==(lhs: NKScene, rhs: NKScene) -> Bool {
    return lhs.windowName == rhs.windowName &&
        lhs.name == rhs.name
}



public class NKStoryboard {
    static var _instance: NKStoryboard?
    var window: NSWindow!
    var scenes = Set<NKScene>()
    var transitions = Set<NKTransition>()
    var views = [NKScene: NKView]()

    var windows = [String: NKWindow]()
    var mainWindow: NKWindow?


    // MARK: - Lifecycles
    // -----------------------------------------------------------------------

    init() {
    }

    public static var instance: NKStoryboard {
        get {
            if _instance == nil { _instance = NKStoryboard() }
            return _instance!
        }
    }



    // MARK: - Registering things
    // -----------------------------------------------------------------------


    public func registerWindow(name: String, window: NKWindow) {
        if windows[name] != nil {
            fatalError("Window with name \(name) is already registered!")
        }

        if windows.count == 0 {
            mainWindow = window
        }

        windows[name] = window
    }

    public func registerScene(name: String, viewClass: NKView.Type, window: String) {
        let scene = NKScene(windowName: window, name: name, viewClass: viewClass)

        if scenes.contains(scene) {
            fatalError("Scene named \(name) in window \(window) was already registered!")
        }

        scenes.insert(scene)
    }

    public func registerTransition(fromScene: String?, toScene: String, window: String, transition: NKTransitionType) {
        let transition = NKTransition(fromScene: fromScene, toScene: toScene, transition: transition, windowName: window)
        transitions.insert(transition)
    }




    // MARK: - Making transitions
    // -----------------------------------------------------------------------

    public func transitionTo(scene: String) {
        transitionTo(scene, context: nil)
    }

    public func transitionTo(sceneName: String, context: AnyObject?) {
        // Find window based on destination scene

        guard let scene = scenes.filter({ $0.name == sceneName }).first else {
            fatalError("No scene named \(sceneName) was found")
        }

        let window = self.windowNamed(scene.windowName)

        window.transitionTo(scene, context: context)

        if !window.visible {
            self.openWindow(window)
        }
    }

    public func findTransition(window: String, fromScene: String?, toScene: String) -> NKTransition? {
        let matching = transitions.filter { transition in
            return transition.windowName == window &&
                transition.fromScene == fromScene &&
                transition.toScene == toScene
        }

        return matching.first

//        return transitions.filter({ $0.windowName == window && $0.fromScene == fromScene && $0.toScene == toScene }).first
    }


    // MARK: Transitioning back

    public func transitionBack(windowName: String) {
        guard let window = windows[windowName] else {
            fatalError("No window named \(windowName) found")
        }

        if window.canNavigateBack {
            window.transitionBack()
        } else {
            self.closeWindow(window)
        }
    }




    // MARK: - Opening/closing windows
    // -----------------------------------------------------------------------

    func openWindow(window: NKWindow) {
        switch(window.openingPolicy) {
        case .Default:
            window.makeKeyAndOrderFront(self)
        case .Sheet:
            self.openWindowAsSheet(window)
        }
    }

    func openWindowAsSheet(window: NKWindow) {
        if window == mainWindow {
            fatalError("Cannot open main window as sheet")
        }

        guard let main = mainWindow else {
            fatalError("Main window must be present in order to open windows as sheets")
        }

        main.beginSheet(window, completionHandler: nil)
    }

    func closeWindow(window: NKWindow) {
        switch(window.openingPolicy) {
        case .Default:
            window.close()
        case .Sheet:
            self.endSheet(window)
        }

        window.popAllTransitions()
    }

    func endSheet(window: NKWindow) {
        guard let main = mainWindow else {
            fatalError("Main window must be present in order to close windows as sheets")
        }

        main.endSheet(window)
    }






    // MARK: - Accessig registered objects
    // -----------------------------------------------------------------------

    func windowNamed(name: String) -> NKWindow {
        if let window = windows[name] {
            return window
        } else {
            fatalError("No window named \(name) was registere")
        }
    }

    func viewFor(scene: NKScene) -> NKView {
        if let view = views[scene] {
            return view
        }

        let cls = scene.viewClass
        let view = cls.init()

        views[scene] = view

        return view
    }





    // MARK: - Helpers
    // -----------------------------------------------------------------------

    var contentView: NSView {
        return window.contentView!
    }

    func updateStatusBar() {
    }




    // MARK: - Alerts
    // -----------------------------------------------------------------------

    public func showAlert(text: String, description: String?) {
        showAlert(text, description: description, callback: nil)
    }

    public func showAlert(text: String, description: String?, callback: NKSimpleCallback?) {
        let alert = NSAlert()
        alert.messageText = text
        alert.informativeText = description ?? ""
        alert.addButtonWithTitle("OK")
        alert.runModal()

        callback?()
    }



}
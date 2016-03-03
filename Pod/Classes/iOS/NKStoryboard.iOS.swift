//
//  NKStoryboard.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 01/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit
import EZAlertController

class NKStoryboard {
    static var _instance: NKStoryboard?


    // MARK: - Stored properties
    // -----------------------------------------------------------------------

    var rootSceneName: String?
    var transitions = Set<NKTransition>()
    var executedTransitions = Array<NKTransition>()
    var viewClasses = [String: NKView.Type]()
    var views = [String: NKView]()
    var controllers = [String: NKViewController]()
    var navigationControllers = Array<UINavigationController>()
    var currentOverlay: XView?




    // MARK: - Lifecycle
    // -----------------------------------------------------------------------

    static var instance: NKStoryboard {
        get {
            if _instance == nil { _instance = NKStoryboard() }
            return _instance!
        }
    }





    // MARK: - Querying state
    // -----------------------------------------------------------------------

    var lastNavigationController: UINavigationController? {
        return navigationControllers.last
    }

    var currentController: NKViewController? {
        return lastNavigationController?.viewControllers.last as! NKViewController?
    }

    var currentSceneName: String? {
        return currentController?.sceneName
    }



    // MARK: - Registering objects
    // -----------------------------------------------------------------------

    func registerScene(name: String, viewClass: NKView.Type) {
        if viewClasses.keys.contains(name) {
            fatalError("Can't add scene named \(name), already has scene with that name!")
        }

        viewClasses[name] = viewClass
    }

    func registerTransition(fromScene: String, toScene: String, transition: NKTransitionType) {
        let transition = NKTransition(fromScene: fromScene, toScene: toScene, transition: transition)
        transitions.insert(transition)
    }

    func setRootScene(scene: String) {
        rootSceneName = scene
    }




    // MARK: - Getting instances
    // -----------------------------------------------------------------------

    func controllerForScene(name: String) -> NKViewController {
        if controllers[name] == nil {
            let view = self.viewForScene(name)
            let controller = NKViewController(view: view)
            controller.sceneName = name

            controllers[name] = controller
        }

        return controllers[name]!
    }

    func controllerForRootScene() -> UIViewController {
        guard let name = rootSceneName else {
            fatalError("Please register root scene before UI initializes")
        }

        return controllerForScene(name)
    }

    func viewForScene(name: String) -> NKView {
        if let view = views[name] {
            return view
        }

        guard let cls = viewClasses[name] else {
            fatalError("Cannot find scene named \(name). Did you register it using registerScene() ?")
        }

        let view = cls.init()
        views[name] = view

        return view
    }

    func transition(from: String, to: String) -> NKTransition {
        let transition = transitions.filter { $0.toScene == to && $0.fromScene == from }.first
        if transition == nil {
            fatalError("No transition from \(from) to \(to)")
        }

        return transition!
    }




    // MARK: - Making transitions
    // -----------------------------------------------------------------------

    func transitionTo(name: String) {
        transitionTo(name, context: nil)
    }

    func transitionTo(name: String, context: AnyObject?) {
        let transition = self.transition(currentSceneName!, to: name)

        let controller = controllerForScene(name)
        controller.setContext(context)

        guard let currentNavigation = self.navigationControllers.last else {
            Log.e("Cannot transition, there are no navigation controllers in the stack")
            return
        }

        guard let currentController = self.currentController else {
            Log.e("Cannot transition, there is no current controller")
            return
        }

        switch(transition.transition) {
        case .Modal:
            let nav = UINavigationController(rootViewController: controller)
            nav.navigationBarHidden = true
            currentController.presentViewController(nav, animated: true, completion: nil)
            controller.controllerThatPresentedModally = currentController
            navigationControllers.append(nav)
        case .Push:
            currentNavigation.pushViewController(controller, animated: true)

        case .Overlay:
            let currentView = currentController.view
            let view = controller.mainView

            currentView.addSubview(view)
            view.expand()

            view.alpha = 0

            UIView.animateWithDuration(0.25) { () -> Void in
                view.alpha = 1
            }

            currentOverlay = view
        }

        executedTransitions.append(transition)
    }

    func transitionBack() {
        transitionBack(nil)
    }

    func transitionBack(window: String?) {
        guard executedTransitions.count > 0 else {
            Log.e("Cannot transition back, no transitions were made")
            return
        }

        let transition = executedTransitions.removeLast()

        switch(transition.transition) {
        case .Modal:
            // TODO: Dismiss
            currentController?.controllerThatPresentedModally?.dismissViewControllerAnimated(true, completion: nil)
            navigationControllers.removeLast()

        case .Push:
            guard let nav = navigationControllers.last else {
                Log.e("Cannot transition back from Push, no navigation controller in the stack")
                return
            }
            nav.popViewControllerAnimated(true)


        case .Overlay:
            guard let view = currentOverlay else { break }

            UIView.animateWithDuration(0.25, animations: { _ in
                view.alpha = 0
            }, completion: { _ in
                view.removeFromSuperview()
            })
        }
    }



    // MARK: - Showing alerts
    // -----------------------------------------------------------------------

    func showAlert(text: String, description: String?) {
        showAlert(text, description: description, callback: nil)
    }

    func showAlert(text: String, description: String?, callback: NKSimpleCallback?) {
        EZAlertController.alert(text, message: description ?? "", acceptMessage: "OK") {
            callback?()
        }
    }



    // MARK: - Helpers
    // -----------------------------------------------------------------------

    func updateStatusBar() {
        currentController?.setNeedsStatusBarAppearanceUpdate()
    }
}



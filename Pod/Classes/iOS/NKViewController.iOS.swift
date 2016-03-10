//
//  NKViewController.iOS.swift
//  FocusList
//
//  Created by Vojtech Rinik on 15/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit


public class NKViewController: UIViewController {
    var mainView: NKView!
    var sceneName: String!
    var controllerThatPresentedModally: UIViewController?

    public convenience init(view: NKView) {
        self.init()

        self.mainView = view
    }

    public override func viewDidLoad() {
        self.view.addSubview(self.mainView)
        mainView.expand()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return mainView.preferredStatusBarStyle()
    }

    public func setContext(context: AnyObject?) {
        mainView.setContext(context)
    }
    
}
//
//  NKViewController.iOS.swift
//  FocusList
//
//  Created by Vojtech Rinik on 15/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit




class NKViewController: UIViewController {
    var mainView: NKView!
    var sceneName: String!
    var controllerThatPresentedModally: UIViewController?

    convenience init(view: NKView) {
        self.init()

        self.mainView = view
    }

    override func viewDidLoad() {
        self.view.addSubview(self.mainView)
        mainView.expand()

        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return mainView.preferredStatusBarStyle()
    }

    func setContext(context: AnyObject?) {
        mainView.setContext(context)
    }
    
}
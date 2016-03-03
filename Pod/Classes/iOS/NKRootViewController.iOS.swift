//
//  NKRootViewController.iOS.swift
//  FocusList
//
//  Created by Vojtech Rinik on 15/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit


class NKRootViewController: UINavigationController {
    override func viewDidLoad() {
        let storyboard = NKStoryboard.instance
        let controller = storyboard.controllerForRootScene()
        viewControllers = [controller]
        storyboard.navigationControllers = [self]
    }
}

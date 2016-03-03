//
//  UIResponder+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 01/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit


private var _currentFirst: UIResponder?

extension UIResponder {
    static var currentFirst: UIResponder? {
        _currentFirst = nil
        UIApplication.sharedApplication().sendAction("findFirstResponder:", to: nil, from: nil, forEvent: nil)
        return _currentFirst
    }

    func findFirstResponder(sender: AnyObject?) {
        _currentFirst = self
    }
}
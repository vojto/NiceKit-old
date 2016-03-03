//
//  XApplication+Additions.iOS.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 13/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    class func sendAction(selector: Selector) {
        UIApplication.sharedApplication().sendAction(selector, to: nil, from: nil, forEvent: nil)
    }
}
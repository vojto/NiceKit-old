//
//  NKCheckbox.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit


class NKCheckbox: NSButton {
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.setButtonType(.SwitchButton)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
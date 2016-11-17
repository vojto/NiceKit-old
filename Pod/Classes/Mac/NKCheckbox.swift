//
//  NKCheckbox.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 11/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit


open class NKCheckbox: NSButton {
    open var onChange: ((Bool, NSEvent) -> ())?
    open var onRightClick: ((NSEvent) -> ())?
    
    open var checked: Bool {
        get {
            return state == NSOnState
        }
        set {
            self.state = newValue ? NSOnState : NSOffState
        }
    }
    
    override public init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.setButtonType(.switch)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override open func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        let checked = (self.state == NSOnState)
        onChange?(checked, event)
    }
    
    override open func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
    }
    
    override open func rightMouseUp(with event: NSEvent) {
        super.rightMouseUp(with: event)
        onRightClick?(event)
    }
}

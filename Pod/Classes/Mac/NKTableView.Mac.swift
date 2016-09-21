//
//  NKTableView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation


import AppKit

open class NKTableView: NSTableView {

    open var onDoubleClick: (() -> ())?
    var onMenu: ((Int) -> (NSMenu?))?

    open var editing = false
    
    
    // Hack that allows us editing custom text fields in custom
    // views
    // Taken from: http://stackoverflow.com/q/7101237
    //
    
    override open func mouseDown(with theEvent: NSEvent) {
        super.mouseDown(with: theEvent)
        
        // NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
        let point = self.convert(theEvent.locationInWindow, from: nil)
        let col = self.column(at: point)
        let row = self.row(at: point)
        
        if row == -1 {
            if theEvent.clickCount == 2 {
                onDoubleClick?()
            }

            return
        }
        
        if let view = self.view(atColumn: col, row: row, makeIfNecessary: false) as? NKTableCellView {
            view.editTextField(theEvent)
        }
    }

    override open func drawGrid(inClipRect clipRect: NSRect) {

    }

    open override func menu(for event: NSEvent) -> NSMenu? {
        if let onMenu = onMenu {
            let pt = convert(event.locationInWindow, from: nil)
            let row = self.row(at: pt)

            return onMenu(row)
        } else {
            return super.menu(for: event)
        }
    }

}

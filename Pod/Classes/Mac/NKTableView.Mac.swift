//
//  NKTableView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation


import AppKit

public class NKTableView: NSTableView {

    public var onDoubleClick: (() -> ())?

    public var editing = false
    
    
    // Hack that allows us editing custom text fields in custom
    // views
    // Taken from: http://stackoverflow.com/q/7101237
    //
    
    override public func mouseDown(theEvent: NSEvent) {
        super.mouseDown(theEvent)
        
        // NSPoint selfPoint = [self convertPoint:theEvent.locationInWindow fromView:nil];
        let point = self.convertPoint(theEvent.locationInWindow, fromView: nil)
        let col = self.columnAtPoint(point)
        let row = self.rowAtPoint(point)
        
        if row == -1 {
            if theEvent.clickCount == 2 {
                onDoubleClick?()
            }

            return
        }
        
        if let view = self.viewAtColumn(col, row: row, makeIfNecessary: false) as? NKTableCellView {
            view.editTextField(theEvent)
        }
    }

    override public func drawGridInClipRect(clipRect: NSRect) {
    }

}

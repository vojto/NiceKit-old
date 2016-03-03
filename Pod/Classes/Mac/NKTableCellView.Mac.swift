//
//  NKTableCellView.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit


public class NKTableCellView: NKView {
    let reuseIdentifier: String
    var selected = false
    var builder: NKTableBuilder!

    // MARK: - Lifecycle
    // -----------------------------------------------------------------------

    required public init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier

        super.init()
    }

    public required init() {
        fatalError("init() has not been implemented")
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Updating
    // -----------------------------------------------------------------------

    public func update(item: NKTableItem) {}

    public func setEditing(editing: Bool, animated: Bool) {
        // Doesn't do anything on Mac
    }

    public func setSelected(selected: Bool, animated: Bool) {
        // Doesn't do anything on Mac
    }

    // MARK: - Hacky OSX stuff
    // -----------------------------------------------------------------------

    func editTextField(event: NSEvent) {
        let point = self.convertPoint(event.locationInWindow, fromView: nil)

        for subview in self.subviews {
            if let textField = subview as? NKTextField {
                if NSPointInRect(point, textField.frame) {
                    textField.handleClickFromTable(event)
                }

            }
        }
    }

    // MARK: - Event handling
    // -----------------------------------------------------------------------


}

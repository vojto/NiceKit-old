//
//  NKTableCellView.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import AppKit


open class NKTableCellView: NKView {
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

    open func update(_ item: NKTableItem) {}

    open func setEditing(_ editing: Bool, animated: Bool) {
        // Doesn't do anything on Mac
    }

    open func setSelected(_ selected: Bool, animated: Bool) {
        // Doesn't do anything on Mac
    }

    // MARK: - Hacky OSX stuff
    // -----------------------------------------------------------------------

    func editTextField(_ event: NSEvent) {
        let point = self.convert(event.locationInWindow, from: nil)

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

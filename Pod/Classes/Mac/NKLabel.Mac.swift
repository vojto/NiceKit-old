//
//  NKLabel.Mac.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public class NKLabel: NKTextField {
    var userInteractionEnabled = true

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)

        self.editable = false
        self.selectable = false
        self.bezeled = false
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public convenience init(text: String) {
        self.init(frame: CGRectZero)

        self.text = text
    }
}
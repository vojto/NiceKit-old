//
//  XTextField+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 05/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension XTextField {

#if os(OSX)

    public var placeholder: String? {
        get { return placeholderString }
        set { placeholderString = newValue }
    }

    public var attributedPlaceholder: NSAttributedString? {
        get { return placeholderAttributedString }
        set { placeholderAttributedString = newValue }
    }

#else


#endif

}
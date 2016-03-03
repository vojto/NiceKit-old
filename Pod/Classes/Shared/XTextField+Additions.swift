//
//  XTextField+Additions.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 05/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

extension XTextField {

#if os(OSX)

    var placeholder: String? {
        get { return placeholderString }
        set { placeholderString = newValue }
    }

    var attributedPlaceholder: NSAttributedString? {
        get { return placeholderAttributedString }
        set { placeholderAttributedString = newValue }
    }

#else


#endif

}
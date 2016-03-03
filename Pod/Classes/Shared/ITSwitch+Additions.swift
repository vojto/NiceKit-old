//
//  ITSwitch+Additions.swift
//  FocusList
//
//  Created by Vojtech Rinik on 21/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import ITSwitch

extension ITSwitch {
    var on: Bool {
        get { return checked }
        set { checked = newValue }
    }

    var onTintColor: XColor? {
        get { return tintColor }
        set { tintColor = newValue }
    }
}
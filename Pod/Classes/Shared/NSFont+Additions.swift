//
//  NSFont+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 28/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension XFont {
#if os(OSX)
    public func getFontDescriptor() -> XFontDescriptor {
        return fontDescriptor
    }
#else
    public func getFontDescriptor() -> XFontDescriptor {
        return fontDescriptor()
    }
#endif

    public func monospaced() -> XFont? {
        let descriptor = getFontDescriptor().addingAttributes([XFontFeatureSettingsAttribute: [[
            XFontFeatureTypeIdentifierKey: 6,
            XFontFeatureSelectorIdentifierKey: 0
            ]]])
        return XFont(descriptor: descriptor, size: 0)
    }
}

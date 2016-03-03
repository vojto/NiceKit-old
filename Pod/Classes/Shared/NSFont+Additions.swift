//
//  NSFont+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 28/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

extension XFont {
#if os(OSX)
    func getFontDescriptor() -> XFontDescriptor {
        return fontDescriptor
    }
#else
    func getFontDescriptor() -> XFontDescriptor {
        return fontDescriptor()
    }
#endif

    func monospaced() -> XFont? {
        let descriptor = getFontDescriptor().fontDescriptorByAddingAttributes([XFontFeatureSettingsAttribute: [[
            XFontFeatureTypeIdentifierKey: 6,
            XFontFeatureSelectorIdentifierKey: 0
            ]]])
        return XFont(descriptor: descriptor, size: 0)
    }
}
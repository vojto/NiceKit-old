//
//  NSString+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics

public extension String {
    func calculateHeight(font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        let attributed = NSAttributedString(string: self)
        return attributed.calculateHeight(font, width: width, padding: padding)
    }

    func substr(startIndex: Int, _ length: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
}

extension NSAttributedString {
    func calculateHeight(font: XFont, width: CGFloat) -> CGFloat {
        let attributedString = self.mutableCopy() as! NSMutableAttributedString
        attributedString.font = font

        let bounds = CGSizeMake(width, 10000)

        #if os(OSX)
        let size = attributedString.boundingRectWithSize(bounds, options: .UsesLineFragmentOrigin)
        #else
        let size = attributedString.boundingRectWithSize(bounds, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)

        #endif

        return ceil(size.height)
    }
    
    func calculateHeight(font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        return self.calculateHeight(font, width: width - padding.horizontal) + padding.vertical
    }
}
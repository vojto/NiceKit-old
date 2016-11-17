//
//  String+Additions.swift
//  Median
//
//  Created by Vojtech Rinik on 06/10/2016.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public extension String {
    func calculateHeight(_ font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        let attributed = NSAttributedString(string: self)
        return attributed.calculateHeight(font, width: width, padding: padding)
    }
    
    func substr(_ startIndex: Int, _ length: Int) -> String {
        
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: (start ..< end))
    }
    
    func substr(_ start: Int, end: Int) -> String {
        return self.substr(start, end - start)
    }
    
    var range: NSRange {
        return NSRange(location: 0, length: (self as NSString).length)
    }
}


extension NSAttributedString {
    func calculateHeight(_ font: XFont, width: CGFloat) -> CGFloat {
        let attributedString = self.mutableCopy() as! NSMutableAttributedString
        attributedString.font = font
        
        let bounds = CGSize(width: width, height: 10000)
        
        #if os(OSX)
            let size = attributedString.boundingRect(with: bounds, options: .usesLineFragmentOrigin)
        #else
            let size = attributedString.boundingRectWithSize(bounds, options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
        #endif
        
        return ceil(size.height)
    }
    
    func calculateHeight(_ font: XFont, width: CGFloat, padding: NKPadding) -> CGFloat {
        return self.calculateHeight(font, width: width - padding.horizontal) + padding.vertical
    }
}

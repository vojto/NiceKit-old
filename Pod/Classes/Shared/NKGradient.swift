//
//  NKGradient.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public enum NKGradientOrientation {
    case Vertical
    case Horizontal
}

public class NKGradient: NKColor {
    public var orientation: NKGradientOrientation = .Vertical

    public init(colors: [XColor]) {
        super.init()
        
        self.colors = colors
    }
    
    public init(hexColors: [String]) {
        super.init()
        
        self.colors = hexColors.map { hex in
            XColor(hexString: hex, alpha: 1)!
        }
    }
}
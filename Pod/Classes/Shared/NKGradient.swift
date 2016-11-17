//
//  NKGradient.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 04/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

public enum NKGradientOrientation {
    case vertical
    case horizontal
}

open class NKGradient: NKColor {
    open var orientation: NKGradientOrientation = .vertical

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

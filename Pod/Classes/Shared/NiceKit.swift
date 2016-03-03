//
//  NiceKit.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public typealias NKSimpleCallback = (() -> Void)

struct NiceKit {
    #if os(OSX)
    static let osx = true
    static let ios = false
    #else
    static let osx = false
    static let ios = true
    #endif
}
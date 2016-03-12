//
//  NiceKit.swift
//  FocusList
//
//  Created by Vojtech Rinik on 12/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public typealias NKSimpleCallback = (() -> Void)

public struct NiceKit {
    #if os(OSX)
        public static let osx = true
        public static let ios = false
    #else
        public static let osx = false
        public static let ios = true
    #endif

    public static var log: ((String) -> Void)?
}
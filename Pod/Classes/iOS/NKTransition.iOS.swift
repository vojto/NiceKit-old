//
//  NKTransition.swift
//  FocusList
//
//  Created by Vojtech Rinik on 15/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

public enum NKTransitionType: String {
    case Push
    case Modal
    case Overlay
}

public struct NKTransition: Hashable {
    let fromScene: String
    let toScene: String
    let transition: NKTransitionType

    public var hashValue: Int {
        return "\(fromScene)\(toScene)\(transition)".hashValue
    }
}

public func ==(lhs: NKTransition, rhs: NKTransition) -> Bool {
    return lhs.fromScene == rhs.fromScene &&
        lhs.toScene == rhs.toScene &&
        lhs.transition == rhs.transition
}
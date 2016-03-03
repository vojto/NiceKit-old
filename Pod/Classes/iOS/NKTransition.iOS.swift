//
//  NKTransition.swift
//  FocusList
//
//  Created by Vojtech Rinik on 15/02/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

enum NKTransitionType: String {
    case Push
    case Modal
    case Overlay
}

struct NKTransition: Hashable {
    let fromScene: String
    let toScene: String
    let transition: NKTransitionType

    var hashValue: Int {
        return "\(fromScene)\(toScene)\(transition)".hashValue
    }
}

func ==(lhs: NKTransition, rhs: NKTransition) -> Bool {
    return lhs.fromScene == rhs.fromScene &&
        lhs.toScene == rhs.toScene &&
        lhs.transition == rhs.transition
}
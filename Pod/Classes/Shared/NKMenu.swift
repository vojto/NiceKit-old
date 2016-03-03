//
//  NKMenu.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation


class NKMenu: NSObject {
    var items: [NKMenuItem] = []
}


class NKMenuItem {
    var label: String?
    var action: (() -> ())?
}
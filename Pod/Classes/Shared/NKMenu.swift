//
//  NKMenu.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation

#if os(OSX)
    import Cocoa
#endif


class NKMenu {
    var items = [NKMenuItem]()
    
    func addItem(_ item: NKMenuItem) {
        items.append(item)
    }
    
    func removeAllItems() {
        items.removeAll()
    }
    
    #if os(OSX)
    func toMenu() -> NSMenu {
        let menu = NSMenu()
        
        for item in items {
            if item.isSeparator {
                menu.addItem(NSMenuItem.separator())
            } else {
                menu.addItem(NSMenuItem(title: item.title, action: item.action, keyEquivalent: ""))
            }
        }
        
        return menu
    }
    #endif
}

class NKMenuItem {
    var title: String
    var action: Selector
    var isSeparator = false
    
    init(title: String, action: Selector) {
        self.title = title
        self.action = action
    }
    
    static func separatorItem() -> NKMenuItem {
        let item = NKMenuItem(title: "", action: "")
        item.isSeparator = true
        return item
    }
}

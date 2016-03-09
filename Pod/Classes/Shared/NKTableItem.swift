//
//  NKTableItem.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 07/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation
import CoreGraphics


public typealias SimpleDict = [String: AnyObject]
public typealias CreateTableViewCallback = (() -> NKTableCellView)


public class NKTableItem {
    public var viewClass: NKTableCellView.Type? = NKTableCellView.self
    public var selectable = true
    public var deletable = false

    public var create: CreateTableViewCallback?
    public var update: ((NKTableCellView) -> ())?

    var row: Int? // TODO: I don't like this information being here. It's duplicate info. We can always just query
                  // XTableView for this information
    public var view: NKTableCellView?

    public var props: SimpleDict?

    var height: CGFloat?

//    var actions: [NKTableViewRowAction]?

    public init() {
    }

    public convenience init(_ viewClass: NKTableCellView.Type, height: CGFloat?) {
        self.init()

        self.viewClass = viewClass
        self.height = height
    }

    public convenience init(_ viewClass: NKTableCellView.Type, height: CGFloat?, props: SimpleDict) {
        self.init()

        self.viewClass = viewClass
        self.height = height
        self.props = props
    }

    public convenience init(_ viewClass: NKTableCellView.Type, props: SimpleDict) {
        self.init()
        
        self.viewClass = viewClass
        self.props = props
    }

    public convenience init(create: CreateTableViewCallback) {
        self.init()

        self.create = create
    }
}

/*
class NKTableViewRowAction {
    typealias NKTableViewRowActionHandler = ((row: Int) -> ())
    let title: String
    let handler: NKTableViewRowActionHandler

    init(title: String, handler: NKTableViewRowActionHandler) {
        self.title = title
        self.handler = handler
    }
}
*/
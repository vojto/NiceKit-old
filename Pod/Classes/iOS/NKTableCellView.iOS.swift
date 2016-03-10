//
//  NKTableCellView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit

public class NKTableCellView: UITableViewCell, NKViewable {
//        var selected = false
    var builder: NKTableBuilder!
    public var style: NKStyle
    public var classes = Set<String>()

    #if os(iOS)
    public var tapRecognizer: UITapGestureRecognizer?
    public var onClick: NKSimpleCallback?
    public var onTap: NKSimpleCallback? {
        didSet {
            if tapRecognizer == nil {
                tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap")
                addGestureRecognizer(tapRecognizer!)
            }
        }
    }

    func handleTap() {
        onTap?()
    }
    
    #else
    
    public var onTap: (() -> ())?
    
    #endif

    required public init(reuseIdentifier: String) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        setup()

        applyLayoutFromChildrenStyles()
    }

    public convenience init(reuseIdentifier: String, setup: SetupCallback) {
        self.init(reuseIdentifier: reuseIdentifier)

        let subviews = setup(view: self)

        for subview in subviews {
            addSubview(subview as! XView)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setup() {
    }

    public func update(item: NKTableItem) {
    }

    public override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        style.draw(rect)
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            addClass("selected")
        } else {
            removeClass("selected")
        }

        setNeedsDisplay()
    }


}


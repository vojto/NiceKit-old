//
//  NKTableCellView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import UIKit

class NKTableCellView: UITableViewCell, NKViewable {
//        var selected = false
    var builder: NKTableBuilder!
    var style: NKStyle
    var classes = Set<String>()

    #if os(iOS)
    var tapRecognizer: UITapGestureRecognizer?
    var onClick: NKSimpleCallback?
    var onTap: NKSimpleCallback? {
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
    
    var onTap: (() -> ())?
    
    #endif

    required init(reuseIdentifier: String) {
        self.style = NKStylesheet.styleForView(self.dynamicType)

        super.init(style: .Default, reuseIdentifier: reuseIdentifier)

        setup()

        applyLayoutFromChildrenStyles()
    }

    convenience init(reuseIdentifier: String, setup: SetupCallback) {
        self.init(reuseIdentifier: reuseIdentifier)

        let subviews = setup(view: self)

        for subview in subviews {
            addSubview(subview as! XView)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
    }

    func update(item: NKTableItem) {
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)

        style.draw(rect)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            addClass("selected")
        } else {
            removeClass("selected")
        }

        setNeedsDisplay()
    }


}


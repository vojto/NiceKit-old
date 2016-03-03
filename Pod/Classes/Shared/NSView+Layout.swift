//
//  NKView+Layout.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 16/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cartography

extension NKViewable {
    public func setup() {
        
    }

    func expandX() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.left == v.superview!.left
            v.right == v.superview!.right
        }
    }

    func expandY() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.top == v.superview!.top
            v.bottom == v.superview!.bottom
        }
    }

    func expandX(left: CGFloat, right: CGFloat) -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.left == v.superview!.left + left
            v.right == v.superview!.right - right
        }
    }

    func centerX() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.centerX == v.superview!.centerX
        }
    }

    func centerY() -> ConstraintGroup {
        return constrain(self as! XView) { v in
            v.centerY == v.superview!.centerY
        }
    }
}

extension XView {
    // MARK: Layout
    
    public func setWidth(width: CGFloat) {
        constrain(self) { view in
            view.width == width
        }
    }
    
    public func setHeight(height: CGFloat) {
        constrain(self) { view in
            view.height == height
        }
    }
    
    public func setSize(width: CGFloat, height: CGFloat) {
        self.setWidth(width)
        self.setHeight(height)
    }
    
    public func expand() -> ConstraintGroup {
        return self.expand(NKPadding(top: 0, right: 0, bottom: 0, left: 0))
    }
    
    public func expand(padding: NKPadding) -> ConstraintGroup {
        return expand(padding, priority: 1000)
    }

    public func expand(padding: NKPadding, priority: Float) -> ConstraintGroup {
        return constrain(self) { v in
            v.bottom == v.superview!.bottom - padding.bottom ~ priority
            v.left == v.superview!.left + padding.left ~ priority
            v.top == v.superview!.top + padding.top ~ priority
            v.right == v.superview!.right - padding.right ~ priority
        }
    }

//    func expandX() ->  ConstraintGroup {
//        return constrain(self) { v in
//            v.left == v.superview!.left
//            v.right == v.superview!.right
//        }
//    }

    public func expandBottom() -> ConstraintGroup {
        return constrain(self) { v in
            v.bottom == v.superview!.bottom
            v.left == v.superview!.left
            v.right == v.superview!.right
        }
    }
    
    func center() -> ConstraintGroup {
        return constrain(self) { v in
            v.centerX == v.superview!.centerX
            v.centerY == v.superview!.centerY
        }
    }



    func centerY() -> ConstraintGroup {
        return constrain(self) { v in
            v.centerY == v.superview!.centerY
        }
    }
}
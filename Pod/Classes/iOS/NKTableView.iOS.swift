//
//  NKTableView.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 07/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation


public class NKTableView: UITableView {

    public override func touchesShouldBegin(touches: Set<UITouch>, withEvent event: UIEvent?, inContentView view: UIView) -> Bool {
        let result =  super.touchesShouldBegin(touches, withEvent: event, inContentView: view)

        NSNotificationCenter.post("NKTableView.touchesShouldBegin", view)

        return result
    }
//
////    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
////        Swift.print("Touches began")
////
////        super.touchesBegan(touches, withEvent: event)
////    }
//
//    public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        Swift.print("Touches began on table")
//
//        super.touchesBegan(touches, withEvent: event)
//    }

}

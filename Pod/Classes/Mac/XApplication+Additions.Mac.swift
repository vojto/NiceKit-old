//
//  NSApplication+Additions.swift
//  Pomodoro X
//
//  Created by Vojtech Rinik on 15/12/15.
//  Copyright © 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cocoa

public extension XApplication {
    class func hideDockIcon() {
        self.setDockIconVisible(false)
    }
    
    class func showDockIcon() {
        self.setDockIconVisible(true)
    }
    
    // Taken from: http://stackoverflow.com/a/26284141/304321
    
    class func setDockIconVisible(state: Bool) -> Bool {
        var result: Bool
        if state {
            result = NSApp.setActivationPolicy(NSApplicationActivationPolicy.Regular)
        } else {
            result = NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        }
        
        NSApp.presentationOptions = .Default
        
        NSMenu.setMenuBarVisible(false)
        NSMenu.setMenuBarVisible(true)
        
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
        
        NSTimer.schedule(delay: 0.1) { _ in
            self.show()
        }
        
        return result
    }
    
    class func show() {
        // TODO: Use storybard here or something


//        NSApp.activateIgnoringOtherApps(true)
//        if let window = (NSApp!.delegate as! NSObject).valueForKey("window") as? NSWindow {
//            window.makeKeyAndOrderFront(nil)
//        }
    }
    
    // Taken from: https://github.com/keith/LoginItemTest
    public class func launchMainAppFromHelperApp() {
        print("Launching")

        let bundlePath = (NSBundle.mainBundle().bundlePath as NSString)

        print("bundle path: \(bundlePath)")
        
        let workspace = NSWorkspace.sharedWorkspace()
        
        let identifier = "rinik.Escape"
        
        if let url = workspace.URLForApplicationWithBundleIdentifier(identifier) {
            var config = [String: AnyObject]()
            config[NSWorkspaceLaunchConfigurationArguments] = ["quiet", "test"] as NSArray
            config[NSWorkspaceLaunchConfigurationEnvironment] = ["quiet": "true"] as NSDictionary
            

            do {
                try workspace.launchApplicationAtURL(url, options: [.Default], configuration: config)
            } catch _ {
                Swift.print("Failed launching app with config: \(config)")
            }
        } else {
            Swift.print("Couldn't find application with identifier \(identifier)")
        }
        
    }

    var applicationState: XApplicationState {
        return .Active
    }

}
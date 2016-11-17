//
//  NKPlatformsIntegration.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 04/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//



#if os(iOS) || os(watchOS) || os(tvOS)

    import UIKit

    public typealias XView = UIView
    public typealias XColor = UIColor
    public typealias XEvent = UIEvent
    public typealias XLabel = UILabel
    public typealias XButton = UIButton
    public typealias XFont = UIFont
    public typealias XFontDescriptor = UIFontDescriptor
    public typealias XImage = UIImage
    public typealias XBezierPath = UIBezierPath
    public typealias XTextField = UITextField
    public typealias XTableView = UITableView
    public typealias XTableViewRowAction = UITableViewRowAction
    public typealias XApplication = UIApplication
    public typealias XSlider = UISlider
    public typealias XDevice = UIDevice
    public typealias XImageView = UIImageView
    public typealias XStatusBarStyle = UIStatusBarStyle
    public typealias XPanGestureRecognizer = UIPanGestureRecognizer
    public typealias XGestureRecognizer = UIGestureRecognizer
    public typealias XScreen = UIScreen
    public typealias XApplicationState = UIApplicationState
    public typealias XSwitch = UISwitch

    public let XFontWeightUltraLight = UIFontWeightUltraLight
    public let XFontWeightThin = UIFontWeightThin
    public let XFontWeightLight = UIFontWeightLight
    public let XFontWeightRegular = UIFontWeightRegular
    public let XFontWeightMedium = UIFontWeightMedium
    public let XFontWeightSemibold = UIFontWeightSemibold
    public let XFontWeightBold = UIFontWeightBold
    public let XFontWeightHeavy = UIFontWeightHeavy
    public let XFontWeightBlack = UIFontWeightBlack

    public typealias XEdgeInsets = UIEdgeInsets
    public let XEdgeInsetsZero = XEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    public let XEdgeInsetsMake = UIEdgeInsetsMake

    public let XGraphicsGetCurrentContext = UIGraphicsGetCurrentContext

    public let XFontFeatureSettingsAttribute = UIFontDescriptorFeatureSettingsAttribute
    public let XFontFeatureTypeIdentifierKey = UIFontFeatureTypeIdentifierKey
    public let XFontFeatureSelectorIdentifierKey = UIFontFeatureSelectorIdentifierKey




#else

    import Cocoa
//    import ITSwitch

    public typealias XView = NSView
    public typealias XButton = NSButton
    public typealias XLabel = NSTextField
    public typealias XColor = NSColor
    public typealias XEvent = NSEvent
    public typealias XFont = NSFont
    public typealias XFontDescriptor = NSFontDescriptor
    public typealias XImage = NSImage
    public typealias XBezierPath = NSBezierPath
    public typealias XTextField = NSTextField
    public typealias XTableView = NSTableView
    public typealias XTableViewRowAction = NSTableViewRowAction
    public typealias XApplication = NSApplication
    public typealias XSlider = NSSlider
    public typealias XPanGestureRecognizer = NSPanGestureRecognizer
    public typealias XGestureRecognizer = NSGestureRecognizer
    public typealias XScreen = NSScreen
    public typealias XImageView = NSImageView
    public typealias XSwitch = ITSwitch

    public let XFontWeightUltraLight = NSFontWeightUltraLight
    public let XFontWeightThin = NSFontWeightThin
    public let XFontWeightLight = NSFontWeightLight
    public let XFontWeightRegular = NSFontWeightRegular
    public let XFontWeightMedium = NSFontWeightMedium
    public let XFontWeightSemibold = NSFontWeightSemibold
    public let XFontWeightBold = NSFontWeightBold
    public let XFontWeightHeavy = NSFontWeightHeavy
    public let XFontWeightBlack = NSFontWeightBlack

    public let XFontFeatureSettingsAttribute = NSFontFeatureSettingsAttribute
    public let XFontFeatureTypeIdentifierKey = NSFontFeatureTypeIdentifierKey
    public let XFontFeatureSelectorIdentifierKey = NSFontFeatureSelectorIdentifierKey

    public typealias XEdgeInsets = EdgeInsets
    public let XEdgeInsetsMake = NSEdgeInsetsMake
    public let XEdgeInsetsZero = XEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    public func XGraphicsGetCurrentContext() -> CGContext {
        return NSGraphicsContext.current()!.cgContext
    }

    public enum XStatusBarStyle {
        case `default`
        case lightContent
    }

    public enum XApplicationState {
        case active
    }

#endif


public let XForegroundColorAttributeName = NSForegroundColorAttributeName
public let XFontAttributeName = NSFontAttributeName
public let XStrikethroughStyleAttributeName = NSStrikethroughStyleAttributeName




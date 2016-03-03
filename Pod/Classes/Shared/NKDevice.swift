//
//  NKDevice.swift
//  Pomodoro Done
//
//  Created by Vojtech Rinik on 15/01/16.
//  Copyright © 2016 Vojtech Rinik. All rights reserved.
//

import Foundation

class NKDevice {
    static var uniqueIdentifier: String {
        #if os(OSX)
            // Get the platform expert
            let platformExpert: io_service_t = IOServiceGetMatchingService(kIOMasterPortDefault, IOServiceMatching("IOPlatformExpertDevice"));

            // Get the serial number as a CFString ( actually as Unmanaged<AnyObject>! )
            let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformSerialNumberKey, kCFAllocatorDefault, 0);

            // Release the platform expert (we're responsible)
            IOObjectRelease(platformExpert);

            // Take the unretained value of the unmanaged-any-object
            // (so we're not responsible for releasing it)
            // and pass it back as a String or, if it fails, an empty string
            return (serialNumberAsCFString.takeUnretainedValue() as? String) ?? ""
        #else
            return XDevice.currentDevice().identifierForVendor?.UUIDString ?? ""
        #endif
    }
}
//
//  NSScreen+DisplayID.swift
//  MewNotch
//
//  Created by Monu Kumar on 08/10/26.
//

import AppKit

extension NSScreen {
    /// Returns the `CGDirectDisplayID` associated with this screen, if available.
    var displayID: CGDirectDisplayID? {
        guard let screenNumber = deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? NSNumber else {
            return nil
        }
        return CGDirectDisplayID(screenNumber.uint32Value)
    }

    /// Whether this screen is an AirPlay or wireless streaming display without hardware timing.
    var isAirPlay: Bool {
        if localizedName.localizedCaseInsensitiveContains("AirPlay") {
            return true
        }
        guard let id = displayID else { return false }
        // 0x61697270 is four-char code 'airp' used by macOS for AirPlay displays
        return CGDisplayModelNumber(id) == 0x61697270
    }
}

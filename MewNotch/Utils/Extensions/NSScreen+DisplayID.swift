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
}

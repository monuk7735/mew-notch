//
//  MediaFilterDefaults.swift
//  MewNotch
//

import SwiftUI

class MediaFilterDefaults: ObservableObject {

    static let shared = MediaFilterDefaults()

    private static var PREFIX: String = "MediaFilter_"

    private init() {}

    @PrimitiveUserDefault(
        PREFIX + "HideShortMedia",
        defaultValue: false
    )
    var hideShortMedia: Bool {
        didSet {
            self.objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "MinimumDuration",
        defaultValue: 90.0
    )
    var minimumDuration: Double {
        didSet {
            self.objectWillChange.send()
        }
    }

    /// Live streams report a duration of 0, so they are never treated as short.
    func shouldHide(duration: Double?) -> Bool {
        guard hideShortMedia, let duration = duration, duration > 0 else {
            return false
        }

        return duration < minimumDuration
    }
}

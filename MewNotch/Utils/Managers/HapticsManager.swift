//
//  HapticsManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 28/03/25.
//

import SwiftUI

class HapticsManager {
    static let shared = HapticsManager()

    private init() {}

    func feedback(
        pattern: NSHapticFeedbackManager.FeedbackPattern
    ) {
        NSHapticFeedbackManager.defaultPerformer
            .perform(
                pattern,
                performanceTime: .default
            )
    }
}

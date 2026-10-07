//
//  Double+Duration.swift
//  MewNotch
//
//  Created by Monu Kumar on 08/10/26.
//

import Foundation
import SwiftUI

extension BinaryFloatingPoint {
    /// Formats seconds into a localized duration string (e.g., "0.5 seconds", "1 second", "2 seconds").
    func formattedSeconds(
        width: Duration.UnitsFormatStyle.UnitWidth = .wide,
        maxFractionalDigits: Int = 1
    ) -> String {
        let hasFraction = Double(self).truncatingRemainder(dividingBy: 1) != 0
        if hasFraction {
            return Duration.seconds(Double(self)).formatted(
                .units(allowed: [.seconds], width: width, fractionalPart: .show(length: maxFractionalDigits))
            )
        } else {
            return Duration.seconds(Double(self)).formatted(
                .units(allowed: [.seconds], width: width)
            )
        }
    }
    
    /// Formats seconds into a `LocalizedStringKey` for SwiftUI components like `SettingsRow`.
    func localizedSecondsKey(
        width: Duration.UnitsFormatStyle.UnitWidth = .wide,
        maxFractionalDigits: Int = 1
    ) -> LocalizedStringKey {
        LocalizedStringKey(formattedSeconds(width: width, maxFractionalDigits: maxFractionalDigits))
    }
    
    /// Formats a time interval in seconds into localized duration units (e.g., hours, minutes).
    func formattedDuration(
        allowedUnits: Set<Duration.UnitsFormatStyle.Unit>,
        width: Duration.UnitsFormatStyle.UnitWidth = .narrow
    ) -> String {
        Duration.seconds(Double(self)).formatted(.units(allowed: allowedUnits, width: width))
    }
    
    /// Formats a number into a localized percentage string (e.g. 0.5 -> "50%", 5 -> "5%").
    /// - Parameter isRatio: Set to true if 1.0 represents 100% (default). Set to false if 50 represents 50%.
    func formattedPercentage(isRatio: Bool = true) -> String {
        let ratio = isRatio ? Double(self) : Double(self) / 100.0
        return ratio.formatted(.percent)
    }
    
    /// Formats a number into a `LocalizedStringKey` representing a localized percentage.
    func localizedPercentageKey(isRatio: Bool = true) -> LocalizedStringKey {
        LocalizedStringKey(formattedPercentage(isRatio: isRatio))
    }
    
    /// Formats a number into a localized multiplier string (e.g. "1.5x", "2x").
    func formattedMultiplier(maxFractionalDigits: Int = 1) -> String {
        let formattedNumber = Double(self).formatted(.number.precision(.fractionLength(0...maxFractionalDigits)))
        return "\(formattedNumber)x"
    }
    
    /// Formats a number into a `LocalizedStringKey` representing a multiplier.
    func localizedMultiplierKey(maxFractionalDigits: Int = 1) -> LocalizedStringKey {
        LocalizedStringKey(formattedMultiplier(maxFractionalDigits: maxFractionalDigits))
    }
}

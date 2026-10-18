//
//  BashEnums.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/10/26.
//

import SwiftUI

enum BashHeaderStyle: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case title = "Title"
    case command = "Command"
    case none = "None"

    var displayName: String {
        switch self {
        case .title:
            String(localized: "Title", comment: "Option to display custom title for Bash script")
        case .command:
            String(localized: "Command", comment: "Option to display command text for Bash script")
        case .none:
            String(localized: "Hidden", comment: "Option to hide header for Bash script")
        }
    }
}

enum BashTextAlignment: String, CaseIterable, Codable, Identifiable {
    var id: String {
        rawValue
    }

    case leading = "Leading"
    case center = "Center"
    case trailing = "Trailing"

    var displayName: String {
        switch self {
        case .leading:
            String(localized: "Left", comment: "Align bash output to the left")
        case .center:
            String(localized: "Center", comment: "Center bash output")
        case .trailing:
            String(localized: "Right", comment: "Align bash output to the right")
        }
    }

    var textAlignment: TextAlignment {
        switch self {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }

    var frameAlignment: Alignment {
        switch self {
        case .leading: .leading
        case .center: .center
        case .trailing: .trailing
        }
    }
}

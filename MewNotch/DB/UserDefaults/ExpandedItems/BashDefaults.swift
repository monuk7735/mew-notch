//
//  BashDefaults.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/02/2026.
//

import SwiftUI

class BashDefaults: ObservableObject {
    static let shared = BashDefaults()

    private static var PREFIX: String = "Bash_"

    private init() {
        if UserDefaults.standard.object(forKey: Self.PREFIX + "HeaderStyle") == nil,
           let legacyShowCommand = UserDefaults.standard.object(forKey: Self.PREFIX + "ShowCommand") as? Bool {
            headerStyle = legacyShowCommand ? .command : .none
            UserDefaults.standard.removeObject(forKey: Self.PREFIX + "ShowCommand")
        }
    }

    @CodableUserDefault(
        PREFIX + "Title",
        defaultValue: "Bash"
    )
    var title: String {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "HeaderStyle",
        defaultValue: BashHeaderStyle.title
    )
    var headerStyle: BashHeaderStyle {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "TextAlignment",
        defaultValue: BashTextAlignment.leading
    )
    var textAlignment: BashTextAlignment {
        didSet {
            objectWillChange.send()
        }
    }

    @CodableUserDefault(
        PREFIX + "Command",
        defaultValue: "echo \"Hello World\""
    )
    var command: String {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "RefreshInterval",
        defaultValue: 5.0
    )
    var refreshInterval: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "WidthMultiplier",
        defaultValue: 1.5
    )
    var widthMultiplier: Double {
        didSet {
            objectWillChange.send()
        }
    }

    @PrimitiveUserDefault(
        PREFIX + "AutoRefresh",
        defaultValue: true
    )
    var autoRefresh: Bool {
        didSet {
            objectWillChange.send()
        }
    }

    var showCommand: Bool {
        get { headerStyle != .none }
        set { headerStyle = newValue ? .command : .none }
    }
}

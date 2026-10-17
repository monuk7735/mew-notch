//
//  PowerManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 07/03/2025.
//

import Foundation

class PowerManager: ObservableObject {
    static let shared = PowerManager()

    private let powerStatus = PowerStatus.sharedInstance() ?? .init()

    private init() {
        powerStatus.providingSource()
    }
}

//
//  BetterDisplayManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 08/10/26.
//

import AppKit
import Foundation

extension NSNotification.Name {
    static let BetterDisplayOSD = NSNotification.Name("MewNotch.BetterDisplayOSD")
}

struct BetterDisplayOSDNotification: Codable {
    let displayID: CGDirectDisplayID?
    let systemIconID: Int?
    let customSymbol: String?
    let text: String?
    let controlTarget: String?
    let value: Float?
    let maxValue: Float?

    enum CodingKeys: String, CodingKey {
        case displayID
        case systemIconID
        case customSymbol
        case text
        case controlTarget
        case value
        case maxValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Flexible decoding for displayID (can be UInt32, Int, or String)
        if let idInt = try? container.decode(CGDirectDisplayID.self, forKey: .displayID) {
            displayID = idInt
        } else if let idString = try? container.decode(String.self, forKey: .displayID), let idInt = CGDirectDisplayID(idString) {
            displayID = idInt
        } else {
            displayID = nil
        }

        systemIconID = try? container.decode(Int.self, forKey: .systemIconID)
        customSymbol = try? container.decode(String.self, forKey: .customSymbol)
        text = try? container.decode(String.self, forKey: .text)
        controlTarget = try? container.decode(String.self, forKey: .controlTarget)

        // Flexible decoding for value
        if let valFloat = try? container.decode(Float.self, forKey: .value) {
            value = valFloat
        } else if let valString = try? container.decode(String.self, forKey: .value), let valFloat = Float(valString) {
            value = valFloat
        } else {
            value = nil
        }

        // Flexible decoding for maxValue
        if let maxFloat = try? container.decode(Float.self, forKey: .maxValue) {
            maxValue = maxFloat
        } else if let maxString = try? container.decode(String.self, forKey: .maxValue), let maxFloat = Float(maxString) {
            maxValue = maxFloat
        } else {
            maxValue = nil
        }
    }
}

class BetterDisplayManager {
    static let shared = BetterDisplayManager()

    private let notificationNames = [
        "pro.betterdisplay.BetterDisplay.osd",
        "me.waydabber.BetterDisplay.osd"
    ]

    private init() {
        startListening()
    }

    func startListening() {
        for name in notificationNames {
            DistributedNotificationCenter.default().addObserver(
                self,
                selector: #selector(handleBetterDisplayOSDNotification(_:)),
                name: NSNotification.Name(name),
                object: nil
            )
        }
    }

    func stopListening() {
        DistributedNotificationCenter.default().removeObserver(self)
    }

    @objc private func handleBetterDisplayOSDNotification(_ notification: Notification) {
        guard let jsonString = notification.object as? String,
              let data = jsonString.data(using: .utf8) else {
            return
        }

        do {
            let osdInfo = try JSONDecoder().decode(BetterDisplayOSDNotification.self, from: data)
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: .BetterDisplayOSD,
                    object: osdInfo
                )
            }
        } catch {
            print("BetterDisplayManager: Failed to decode OSD notification: \(error)")
        }
    }
}

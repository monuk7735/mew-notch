//
//  MediaKeyManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/26.
//

import ApplicationServices
import Cocoa
import CoreGraphics
import Foundation

class MediaKeyManager {
    static let shared = MediaKeyManager()

    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    private let nxKeytypeSoundUp: Int32 = 0
    private let nxKeytypeSoundDown: Int32 = 1
    private let nxKeytypeBrightnessUp: Int32 = 2
    private let nxKeytypeBrightnessDown: Int32 = 3
    private let nxKeytypeMute: Int32 = 7

    private let kCGEventSystemDefined = CGEventType(rawValue: 14)!

    private init() {}

    func start() {
        if eventTap != nil {
            return
        }

        let trusted = AXIsProcessTrusted()

        guard trusted else { return }

        let eventMask = (1 << kCGEventSystemDefined.rawValue) | (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { proxy, type, event, refcon -> Unmanaged<CGEvent>? in
                MediaKeyManager.shared.handle(proxy: proxy, type: type, event: event, refcon: refcon)
            },
            userInfo: nil
        ) else { return }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)

        if let source = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
        }
    }

    func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
                runLoopSource = nil
            }
            eventTap = nil
        }
    }

    private func handle(proxy _: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon _: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
        if type == .tapDisabledByTimeout {
            if let tap = eventTap {
                CGEvent.tapEnable(tap: tap, enable: true)
            }
            return Unmanaged.passUnretained(event)
        }

        if type == .keyDown || type == .keyUp {
            return Unmanaged.passUnretained(event)
        }

        if type.rawValue == 14 {
            let subtypeField = CGEventField(rawValue: 160)!
            let data1Field = CGEventField(rawValue: 161)!

            var subtype = event.getIntegerValueField(subtypeField)
            var data1 = event.getIntegerValueField(data1Field)

            if subtype == 0, let nsEvent = NSEvent(cgEvent: event) {
                if nsEvent.type == .systemDefined {
                    let nsSubtype = Int64(nsEvent.subtype.rawValue)
                    let nsData1 = Int64(nsEvent.data1)
                    if nsSubtype != 0 {
                        subtype = nsSubtype
                        data1 = nsData1
                    }
                }
            }

            let keyCode = Int32((data1 >> 16) & 0xFFFF)
            let keyFlags = data1 & 0xFFFF
            let isKeyDown = ((keyFlags & 0xFF00) >> 8) == 0xA
            let isKeyUp = ((keyFlags & 0xFF00) >> 8) == 0xB

            if subtype == 8, handleMediaKey(keyCode: keyCode, isKeyDown: isKeyDown, isKeyUp: isKeyUp) {
                return nil
            }
        }

        return Unmanaged.passUnretained(event)
    }

    private func handleMediaKey(keyCode: Int32, isKeyDown: Bool, isKeyUp: Bool) -> Bool {
        if isKeyDown {
            switch keyCode {
            case nxKeytypeSoundUp:
                if HUDAudioOutputDefaults.shared.isEnabled {
                    handleVolume(change: Float(HUDAudioOutputDefaults.shared.step))
                    return true
                }
            case nxKeytypeSoundDown:
                if HUDAudioOutputDefaults.shared.isEnabled {
                    handleVolume(change: -Float(HUDAudioOutputDefaults.shared.step))
                    return true
                }
            case nxKeytypeMute:
                if HUDAudioOutputDefaults.shared.isEnabled {
                    handleMute()
                    return true
                }
            case nxKeytypeBrightnessUp:
                if NotchDefaults.shared.yieldBrightnessToBetterDisplay && BetterDisplayManager.shared.isBetterDisplayRunning {
                    return false
                }
                if HUDBrightnessDefaults.shared.isEnabled {
                    handleBrightness(change: Float(HUDBrightnessDefaults.shared.step))
                    return true
                }
            case nxKeytypeBrightnessDown:
                if NotchDefaults.shared.yieldBrightnessToBetterDisplay && BetterDisplayManager.shared.isBetterDisplayRunning {
                    return false
                }
                if HUDBrightnessDefaults.shared.isEnabled {
                    handleBrightness(change: -Float(HUDBrightnessDefaults.shared.step))
                    return true
                }
            default:
                break
            }
        } else if isKeyUp {
            switch keyCode {
            case nxKeytypeSoundUp, nxKeytypeSoundDown, nxKeytypeMute:
                return HUDAudioOutputDefaults.shared.isEnabled
            case nxKeytypeBrightnessUp, nxKeytypeBrightnessDown:
                if NotchDefaults.shared.yieldBrightnessToBetterDisplay && BetterDisplayManager.shared.isBetterDisplayRunning {
                    return false
                }
                return HUDBrightnessDefaults.shared.isEnabled
            default:
                break
            }
        }
        return false
    }

    private func handleVolume(change: Float) {
        let currentVol = AudioOutput.sharedInstance().volume * 100
        var newVol = currentVol + change
        newVol = max(0, min(100, newVol))
        AudioOutput.sharedInstance().volume = newVol / 100.0

        if AudioOutput.sharedInstance().isMute, change != 0 {
            AudioOutput.sharedInstance().isMute = false
        }
    }

    private func handleMute() {
        let isMuted = AudioOutput.sharedInstance().isMute
        AudioOutput.sharedInstance().isMute = !isMuted
    }

    private func handleBrightness(change: Float) {
        let current = Brightness.sharedInstance().brightness
        var newBright = current + change
        newBright = max(0, min(1, newBright))
        Brightness.sharedInstance().setBrightness(newBright, smooth: HUDBrightnessDefaults.shared.animateChanges)
    }
}

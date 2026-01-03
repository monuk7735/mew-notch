//
//  MediaKeyManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/01/26.
//

import Foundation
import CoreGraphics
import Cocoa
import ApplicationServices

class MediaKeyManager {
    
    static let shared = MediaKeyManager()
    
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    
    private let NX_KEYTYPE_SOUND_UP: Int32 = 0
    private let NX_KEYTYPE_SOUND_DOWN: Int32 = 1
    private let NX_KEYTYPE_BRIGHTNESS_UP: Int32 = 2
    private let NX_KEYTYPE_BRIGHTNESS_DOWN: Int32 = 3
    private let NX_KEYTYPE_MUTE: Int32 = 7
    
    private let kCGEventSystemDefined = CGEventType(rawValue: 14)!
    
    private init() { }

    public func start() {
        if eventTap != nil { return }
        
        let trusted = AXIsProcessTrusted()
        
        guard trusted else { return }

        let eventMask = (1 << kCGEventSystemDefined.rawValue) | (1 << CGEventType.keyDown.rawValue) | (1 << CGEventType.keyUp.rawValue)
        
        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(eventMask),
            callback: { (proxy, type, event, refcon) -> Unmanaged<CGEvent>? in
                return MediaKeyManager.shared.handle(proxy: proxy, type: type, event: event, refcon: refcon)
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

    public func stop() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let source = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
                runLoopSource = nil
            }
            eventTap = nil
        }
    }
    
    private func handle(proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon: UnsafeMutableRawPointer?) -> Unmanaged<CGEvent>? {
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
            
            if subtype == 8 {
                if isKeyDown {
                    switch keyCode {
                    case NX_KEYTYPE_SOUND_UP:
                        if HUDAudioOutputDefaults.shared.isEnabled {
                            handleVolume(change: Float(HUDAudioOutputDefaults.shared.step))
                            return nil
                        }
                    case NX_KEYTYPE_SOUND_DOWN:
                        if HUDAudioOutputDefaults.shared.isEnabled {
                            handleVolume(change: -Float(HUDAudioOutputDefaults.shared.step))
                            return nil
                        }
                    case NX_KEYTYPE_MUTE:
                        if HUDAudioOutputDefaults.shared.isEnabled {
                           handleMute()
                           return nil
                        }
                    case NX_KEYTYPE_BRIGHTNESS_UP:
                        if HUDBrightnessDefaults.shared.isEnabled {
                             handleBrightness(change: Float(HUDBrightnessDefaults.shared.step))
                             return nil
                        }
                    case NX_KEYTYPE_BRIGHTNESS_DOWN:
                        if HUDBrightnessDefaults.shared.isEnabled {
                            handleBrightness(change: -Float(HUDBrightnessDefaults.shared.step))
                            return nil
                        }
                    default:
                        break
                    }
                } else if ((keyFlags & 0xFF00) >> 8) == 0xB {
                    switch keyCode {
                    case NX_KEYTYPE_SOUND_UP, NX_KEYTYPE_SOUND_DOWN, NX_KEYTYPE_MUTE:
                        if HUDAudioOutputDefaults.shared.isEnabled {
                             return nil
                        }
                    case NX_KEYTYPE_BRIGHTNESS_UP, NX_KEYTYPE_BRIGHTNESS_DOWN:
                        if HUDBrightnessDefaults.shared.isEnabled {
                            return nil
                        }
                    default:
                        break
                    }
                }
            }
        }
        
        return Unmanaged.passUnretained(event)
    }
    
    private func handleVolume(change: Float) {
        let currentVol = AudioOutput.sharedInstance().volume * 100
        var newVol = currentVol + change
        newVol = max(0, min(100, newVol))
        AudioOutput.sharedInstance().volume = newVol / 100.0
        
        if AudioOutput.sharedInstance().isMute && change != 0 {
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
        Brightness.sharedInstance().brightness = newBright
    }
}

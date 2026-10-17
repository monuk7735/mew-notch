//
//  VolumeManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import AppKit

class VolumeManager {
    static let shared = VolumeManager()

    var outputAudio: AudioOutput = .sharedInstance()
    var inputAudio: AudioInput = .sharedInstance()

    private init() {}

    func isInputMuted() -> Bool {
        inputAudio.isMute
    }

    func isOutputMuted() -> Bool {
        outputAudio.isMute
    }

    func getInputDeviceName() -> String {
        inputAudio.deviceName
    }

    func getOutputDeviceName() -> String {
        outputAudio.deviceName
    }

    func getInputVolume() -> Float {
        if isInputMuted() {
            return 0.0
        }

        return inputAudio.volume
    }

    func getOutputVolume() -> Float {
        if isOutputMuted() {
            return 0.0
        }

        return outputAudio.volume
    }
}

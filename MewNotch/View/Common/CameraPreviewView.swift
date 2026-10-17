//
//  CameraPreviewView.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/04/25.
//

import AVFoundation
import SwiftUI

struct CameraPreviewView: NSViewRepresentable {
    func makeNSView(context _: Context) -> CameraPreviewNSView {
        CameraPreviewNSView()
    }

    func updateNSView(_: CameraPreviewNSView, context _: Context) {}

    class CameraPreviewNSView: NSView {
        private let session = AVCaptureSession()
        private let sessionQueue = DispatchQueue(label: "com.mewnotch.cameraSessionQueue")
        private var previewLayer: AVCaptureVideoPreviewLayer?

        override init(frame frameRect: NSRect) {
            super.init(frame: frameRect)
            setup()
        }

        required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)
            setup()
        }

        deinit {
            let session = self.session
            let sessionQueue = self.sessionQueue
            sessionQueue.async {
                session.stopRunning()
            }
        }

        private func setup() {
            // Setup Layer immediately (session is empty but exists)
            let previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
            previewLayer.frame = bounds

            layer = previewLayer
            wantsLayer = true
            self.previewLayer = previewLayer

            startSession()
        }

        private func startSession() {
            sessionQueue.async { [weak self] in
                guard let self else { return }

                session.beginConfiguration()
                session.sessionPreset = .high

                let discoverySession = AVCaptureDevice.DiscoverySession(
                    deviceTypes: [.builtInWideAngleCamera, .external],
                    mediaType: .video,
                    position: .unspecified
                )

                guard let camera = discoverySession.devices.first else {
                    session.commitConfiguration()
                    return
                }

                do {
                    let input = try AVCaptureDeviceInput(device: camera)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                } catch {
                    print("Error creating device input: \(error)")
                }

                session.commitConfiguration()

                session.startRunning()

                DispatchQueue.main.async {
                    if let connection = self.previewLayer?.connection {
                        if connection.isVideoMirroringSupported {
                            connection.automaticallyAdjustsVideoMirroring = false
                            connection.isVideoMirrored = true // Mirror for "Mirror" view!
                        }
                    }
                }
            }
        }
    }
}

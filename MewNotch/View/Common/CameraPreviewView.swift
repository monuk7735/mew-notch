//
//  CameraPreviewView.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/04/25.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: NSViewRepresentable {
    
    let session = AVCaptureSession()
    
    class CameraPreviewNSView: NSView {
        
        private var session: AVCaptureSession?

        override init(
            frame frameRect: NSRect
        ) {
            super.init(
                frame: frameRect
            )
            setupSession()
        }

        required init?(
            coder decoder: NSCoder
        ) {
            super.init(
                coder: decoder
            )
            setupSession()
        }
        
        deinit {
            session?.stopRunning()
        }

        private func setupSession() {
            let session = AVCaptureSession()
            session.sessionPreset = .high

            guard let camera = AVCaptureDevice.default(
                for: .video
            ), let input = try? AVCaptureDeviceInput(
                device: camera
            ), session.canAddInput(
                input
            ) else {
                return
            }

            session.addInput(input)

            let previewLayer = AVCaptureVideoPreviewLayer(
                session: session
            )
            
            previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
            previewLayer.connection?.isVideoMirrored = previewLayer.connection?.isVideoMirroringSupported ?? true
            
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = bounds
            previewLayer.autoresizingMask = [
                .layerWidthSizable,
                .layerHeightSizable,
            ]

            self.wantsLayer = true
            self.layer = previewLayer

            self.session = session
            session.startRunning()
        }
    }

    func makeNSView(
        context: Context
    ) -> CameraPreviewNSView {
        return CameraPreviewNSView()
    }

    func updateNSView(
        _ nsView: CameraPreviewNSView,
        context: Context
    ) {}
}

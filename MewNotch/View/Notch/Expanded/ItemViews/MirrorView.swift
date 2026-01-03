//
//  MirrorView.swift
//  MewNotch
//
//  Created by Monu Kumar on 19/04/25.
//

import SwiftUI
import AVFoundation

struct MirrorView: View {
    
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var mirrorDefaults = MirrorDefaults.shared
    
    @State private var isCameraViewShown: Bool = false
    @State private var cameraAuthStatus: AVAuthorizationStatus = .notDetermined
    
    // Helper to request/check auth
    func updateCameraAuthorization(animate: Bool = true) {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        if animate {
            withAnimation { self.cameraAuthStatus = status }
        } else {
            self.cameraAuthStatus = status
        }
    }

    func requestCameraAuthorization() {
        AVCaptureDevice.requestAccess(for: .video) { _ in
            self.updateCameraAuthorization()
        }
    }
    
    var body: some View {
        ZStack {
            // Background Shape
            RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius)
                .fill(Color.gray.opacity(0.2)) // Darker background for contrast
            
            if cameraAuthStatus == .authorized {
                if isCameraViewShown {
                    CameraPreviewView()
                        .clipShape(
                            RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    // Placeholder when camera is OFF but authorized
                    Image(systemName: "person.fill")
                        .resizable()
                        .scaledToFit()
                        .padding(32)
                        .foregroundStyle(.white.opacity(0.8))
                        .transition(.opacity.combined(with: .scale(scale: 0.9)))
                }
            } else {
                // Not Authorized / Denied / Not Determined State
                VStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.yellow)
                    
                    Text(cameraAuthStatus == .notDetermined ? "Tap to Allow" : "No Access")
                        .font(.caption2.bold())
                        .foregroundStyle(.white)
                }
                .padding(8)
            }
        }
        .frame(
            width: notchViewModel.notchSize.height * 3
        )
        .clipShape(RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius * notchViewModel.notchSize.height * 3 * 0.01))
        .onTapGesture {
            handleTap()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active { updateCameraAuthorization() }
        }
        .onChange(of: notchViewModel.isExpanded) { _, isExpanded in
            if !isExpanded { isCameraViewShown = false }
        }
        .onAppear {
            updateCameraAuthorization(animate: false)
        }
    }
    
    private func handleTap() {
        if cameraAuthStatus == .authorized {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isCameraViewShown.toggle()
            }
        } else if cameraAuthStatus == .notDetermined {
            requestCameraAuthorization()
        } else if cameraAuthStatus == .denied {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Camera") {
                openURL(url)
            }
        }
    }
}

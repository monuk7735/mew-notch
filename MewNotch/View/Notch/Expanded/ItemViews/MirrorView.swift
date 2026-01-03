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
            RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.15),
                            Color(white: 0.05)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    LinearGradient(
                        colors: [
                            .white.opacity(0.0),
                            .white.opacity(0.2),
                            .white.opacity(0.0)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .clipShape(RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius))
                )
            
            if cameraAuthStatus == .authorized {
                if isCameraViewShown {
                    CameraPreviewView()
                        .background {
                            ProgressView()
                        }
                        .clipShape(
                            RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius)
                        )
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                } else {
                    // Placeholder when camera is OFF but authorized
                    VStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: notchViewModel.notchSize.height * 0.8) // Reduce icon size slightly to fit text
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white.opacity(0.8), .white.opacity(0.4)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                        
                        Text("Mirror")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundStyle(.white.opacity(0.6))
                    }
                }
            } else {
                // Not Authorized / Denied / Not Determined State
                VStack(spacing: 4) {
                    Image(systemName: "video.slash.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .foregroundStyle(.secondary)
                    
                    Text("Mirror")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    
                    Text(cameraAuthStatus == .notDetermined ? "Tap to Allow Camera" : "Camera Access Required")
                        .font(.system(size: 8))
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 4)
                }
                .padding(8)
            }
        }
        .frame(
            width: notchViewModel.notchSize.height * 3
        )
        .clipShape(RoundedRectangle(cornerRadius: mirrorDefaults.cornerRadius))
        .shadow(color: .white.opacity(0.1), radius: 1, x: 0, y: 1) // Subtle rim lighting
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

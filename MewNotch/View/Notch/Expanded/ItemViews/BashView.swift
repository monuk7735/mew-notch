//
//  BashView.swift
//  MewNotch
//
//  Created by Monu Kumar on 11/02/2026.
//

import SwiftUI

struct BashView: View {
    @ObservedObject var notchViewModel: NotchViewModel
    @StateObject private var bashDefaults = BashDefaults.shared
    @State private var output: String = "Running..."
    @State private var isRunning: Bool = false
    @State private var hasError: Bool = false
    @State private var timer: Timer?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if bashDefaults.headerStyle != .none {
                HStack(spacing: 6) {
                    AppIcon.terminalFill.image
                        .font(.caption)
                        .foregroundStyle(hasError ? Color.red : Color.secondary)

                    let headerText = bashDefaults.headerStyle == .title
                        ? (bashDefaults.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Bash" : bashDefaults.title)
                        : bashDefaults.command

                    Text(headerText)
                        .font(.caption2)
                        .fontWeight(bashDefaults.headerStyle == .title ? .medium : .regular)
                        .foregroundStyle(hasError ? Color.red.opacity(0.8) : Color.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Spacer()

                    if isRunning {
                        ProgressView()
                            .scaleEffect(0.4)
                            .frame(width: 8, height: 8)
                    } else if hasError {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, 2)
            }

            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .multilineTextAlignment(bashDefaults.textAlignment.textAlignment)
                    .frame(maxWidth: .infinity, alignment: bashDefaults.textAlignment.frameAlignment)
            }
        }
        .padding()
        .frame(width: notchViewModel.notchSize.width * bashDefaults.widthMultiplier)
        .frame(maxHeight: .infinity)
        .background(AppColor.Surface.overlay)
        .cornerRadius(12)
        .contextMenu {
            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(output, forType: .string)
            } label: {
                Label("Copy Output", systemImage: "doc.on.doc")
            }

            Button {
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(bashDefaults.command, forType: .string)
            } label: {
                Label("Copy Command", systemImage: "terminal")
            }
        }
        .onAppear {
            runCommand()
            startTimer()
        }
        .onDisappear {
            stopTimer()
        }
        .onChange(of: bashDefaults.refreshInterval) {
            stopTimer()
            startTimer()
        }
        .onChange(of: bashDefaults.autoRefresh) {
            stopTimer()
            startTimer()
        }
        .onChange(of: bashDefaults.command) {
            runCommand()
        }
    }

    private func startTimer() {
        stopTimer()
        guard bashDefaults.autoRefresh else { return }

        timer = Timer.scheduledTimer(withTimeInterval: bashDefaults.refreshInterval, repeats: true) { _ in
            runCommand()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func runCommand() {
        isRunning = true
        let commandToRun = bashDefaults.command

        DispatchQueue.global(qos: .userInitiated).async {
            let task = Process()
            let pipe = Pipe()

            var environment = ProcessInfo.processInfo.environment
            let userHome = NSHomeDirectory()
            let paths = [
                "/opt/homebrew/bin",
                "/opt/homebrew/sbin",
                "/usr/local/bin",
                "/usr/local/sbin",
                "\(userHome)/.local/bin",
                "/usr/bin",
                "/bin",
                "/usr/sbin",
                "/sbin"
            ]
            let currentPath = environment["PATH"] ?? ""
            let combinedPath = (paths + currentPath.split(separator: ":").map(String.init))
                .reduce(into: [String]()) { result, path in
                    if !result.contains(path) {
                        result.append(path)
                    }
                }
                .joined(separator: ":")
            environment["PATH"] = combinedPath
            environment["HOME"] = userHome
            task.environment = environment

            task.standardOutput = pipe
            task.standardError = pipe
            task.arguments = ["-c", commandToRun]
            task.launchPath = "/bin/bash"

            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                task.waitUntilExit()

                let exitStatus = task.terminationStatus
                let outputString = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                DispatchQueue.main.async {
                    isRunning = false
                    hasError = (exitStatus != 0)
                    output = outputString.isEmpty ? (exitStatus != 0 ? "Exited with code \(exitStatus)" : "No Output") : outputString
                }
            } catch {
                DispatchQueue.main.async {
                    isRunning = false
                    hasError = true
                    output = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

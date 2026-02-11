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
    @State private var timer: Timer?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if bashDefaults.showCommand {
                HStack {
                    Image(systemName: "terminal.fill")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(bashDefaults.command)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    
                    Spacer()
                }
                .padding(.bottom, 2)
            }
            
            ScrollView {
                Text(output)
                    .font(.system(.caption, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .frame(width: notchViewModel.notchSize.width * bashDefaults.widthMultiplier)
        .frame(maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(12)
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
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", bashDefaults.command]
        task.launchPath = "/bin/bash"
        
        do {
            try task.run()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let outputString = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.output = outputString.trimmingCharacters(in: .whitespacesAndNewlines)
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.output = "Error: \(error.localizedDescription)"
            }
        }
    }
}

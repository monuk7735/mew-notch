//
//  OSDUIManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 26/02/25.
//

import Foundation

class OSDUIManager {
    
    static let shared = OSDUIManager()
    
    private var timer: Timer?
    
    private init() {}

    public func start() {
        do {
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-9", "OSDUIHelper"]
            
            try task.run()
        } catch {
            NSLog("Error while trying to re-enable OSDUIHelper. \(error)")
        }
    }

    public func stop() {
        do {
            let kickstart = Process()
            
            kickstart.executableURL = URL(fileURLWithPath: "/bin/launchctl")
            
            // When macOS boots, OSDUIHelper does not start until a volume button is pressed. We can workaround this by kickstarting it.
            
            kickstart.arguments = ["kickstart", "gui/\(getuid())/com.apple.OSDUIHelper"]
            
            try kickstart.run()
            kickstart.waitUntilExit()
            
            usleep(500000) // Wait a bit
            
            let task = Process()
            
            task.executableURL = URL(fileURLWithPath: "/usr/bin/killall")
            task.arguments = ["-STOP", "OSDUIHelper"]
            
            try task.run()
        } catch {
            NSLog("Error while trying to hide OSDUIHelper. Please create an issue on GitHub. Error: \(error)")
        }
    }
    
    public func reset() {
        start()
        
        stop()
    }
    
    func startMonitoring() {
        timer = Timer.scheduledTimer(
            timeInterval: 30,
            target: self,
            selector: #selector(killIfRunning),
            userInfo: nil,
            repeats: true
        )
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func killIfRunning() {
        let count = countOSDUIHelperInstances() ?? 0
        
        if count > 1 {
            self.stop()
        }
    }
    
    private func countOSDUIHelperInstances() -> Int? {
        let ps = Process()
        let grep = Process()
        let wc = Process()
        let tr = Process()

        let psPipe = Pipe()
        let grepPipe = Pipe()
        let wcPipe = Pipe()
        let trPipe = Pipe()

        // ps aux
        ps.executableURL = URL(fileURLWithPath: "/bin/ps")
        ps.arguments = ["aux"]
        ps.standardOutput = psPipe

        // grep "OSDUIHelper"
        grep.executableURL = URL(fileURLWithPath: "/usr/bin/grep")
        grep.arguments = ["OSDUIHelper"]
        grep.standardInput = psPipe
        grep.standardOutput = grepPipe

        // wc -l
        wc.executableURL = URL(fileURLWithPath: "/usr/bin/wc")
        wc.arguments = ["-l"]
        wc.standardInput = grepPipe
        wc.standardOutput = wcPipe

        // tr -d " "
        tr.executableURL = URL(fileURLWithPath: "/usr/bin/tr")
        tr.arguments = ["-d", " "]
        tr.standardInput = wcPipe
        tr.standardOutput = trPipe

        do {
            try ps.run()
            try grep.run()
            try wc.run()
            try tr.run()

            tr.waitUntilExit()
        } catch {
            print("Error running command chain: \(error)")
            return nil
        }

        let data = trPipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8),
              let count = Int(output.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return nil
        }

        return count
    }
}

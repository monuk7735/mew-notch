//
//  AirDropManager.swift
//  MewNotch
//
//  Created by Monu Kumar on 03/07/25.
//


class AirDrop: NSObject, NSSharingServiceDelegate {
    
    private let files: [URL]
    private var completion: ((Error?) -> Void)?
    
    init(
        files: [URL]
    ) {
        self.files = files
        
        super.init()
    }
    
    func begin(completion: ((Error?) -> Void)? = nil) {
        self.completion = completion
        do {
            try send(files)
        } catch {
            completion?(error)
        }
    }
    
    private func send(
        _ files: [URL]
    ) throws {
        guard let service = NSSharingService(
            named: .sendViaAirDrop
        ) else {
            throw NSError(
                domain: "AirDrop",
                code: 1,
                userInfo: [
                    NSLocalizedDescriptionKey: String(
                        localized: "AirDrop service could not be initialised",
                        comment: "Error description when AirDrop service cannot be created"
                    )
                ]
            )
        }
        guard service.canPerform(
            withItems: files
        ) else {
            throw NSError(
                domain: "AirDrop",
                code: 2,
                userInfo: [
                    NSLocalizedDescriptionKey: String(
                        localized: "File cannot be sent with AirDrop",
                        comment: "Error description when dropped files cannot be shared via AirDrop"
                    )
                ]
            )
        }
        
        service.delegate = self
        
        service.perform(
            withItems: files
        )
    }
    
    // MARK: - NSSharingServiceDelegate
    
    func sharingService(_ sharingService: NSSharingService, didFailToShareItems items: [Any], error: Error) {
        completion?(error)
    }
    
    func sharingService(_ sharingService: NSSharingService, didShareItems items: [Any]) {
        completion?(nil)
    }
}

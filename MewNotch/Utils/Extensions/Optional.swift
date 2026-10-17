//
//  Optional.swift
//  MewNotch
//
//  Created by Monu Kumar on 24/11/25.
//

public extension Optional {
    func ifNil(_ fallback: @autoclosure () -> Wrapped) -> Wrapped {
        if let self {
            return self
        }
        return fallback()
    }

    func ifNil(_ condition: Bool, _ fallback: @autoclosure () -> Wrapped?) -> Wrapped? {
        if let self {
            return self
        }
        return condition ? fallback() : nil
    }
}

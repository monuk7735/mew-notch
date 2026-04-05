//
//  PrimitiveUserDefault.swift
//  MewNotch
//
//  Created by Monu Kumar on 23/03/25.
//
import SwiftUI
import Combine

@propertyWrapper
public struct PrimitiveUserDefault<T> {
    
    public let key: String
    public let defaultValue: T
    public let suiteName: String?
    
    public init(
        _ key: String,
        defaultValue: T,
        suiteName: String? = nil
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.suiteName = suiteName
    }
    
    public var wrappedValue: T {
        get {
            let defaults = suiteName != nil ? UserDefaults(
                suiteName: suiteName!
            ): UserDefaults.standard
            
            return defaults?.object(
                forKey: key
            ) as? T ?? defaultValue
        }
        set {
            let defaults = suiteName != nil ? UserDefaults(suiteName: suiteName!) : UserDefaults.standard
            defaults?.set(newValue, forKey: key)
        }
    }
    
    public static subscript<EnclosingSelf: ObservableObject>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, T>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Self>
    ) -> T {
        get {
            object[keyPath: storageKeyPath].wrappedValue
        }
        set {
            if let publisher = object.objectWillChange as? ObservableObjectPublisher {
                publisher.send()
            }
            object[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
}

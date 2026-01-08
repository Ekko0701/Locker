//
//  KeychainWrapper.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// Keychain PropertyWrapper
///
/// 사용 예시:
/// ```swift
/// @Keychain(key: "accessToken")
/// var accessToken: String?
///
/// @Keychain(key: "password", accessibility: .whenUnlockedThisDeviceOnly)
/// var password: String?
/// ```
@propertyWrapper
public struct Keychain<T: Codable> {
    private let key: String
    private let accessibility: KeychainAccessibility
    private let storage: KeychainStorage
    
    /// 초기화
    /// - Parameters:
    ///   - key: 저장 키
    ///   - accessibility: Keychain 접근성 옵션
    ///   - service: Keychain 서비스 이름
    ///   - accessGroup: Keychain Access Group (App Groups 사용 시)
    public init(
        key: String,
        accessibility: KeychainAccessibility = .afterFirstUnlock,
        service: String? = nil,
        accessGroup: String? = nil
    ) {
        self.key = key
        self.accessibility = accessibility
        self.storage = KeychainStorage(
            service: service ?? Bundle.main.bundleIdentifier ?? "com.locker.default",
            accessGroup: accessGroup
        )
    }
    
    public var wrappedValue: T? {
        get {
            try? storage.load(forKey: key)
        }
        set {
            if let value = newValue {
                try? storage.save(value, forKey: key, accessibility: accessibility)
            } else {
                try? storage.delete(forKey: key)
            }
        }
    }
}



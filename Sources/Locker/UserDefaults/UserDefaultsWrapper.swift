//
//  UserDefaultsWrapper.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// UserDefaults PropertyWrapper
///
/// 사용 예시:
/// ```swift
/// @UserDefault(key: "isDarkMode", defaultValue: false)
/// var isDarkMode: Bool
/// ```
@propertyWrapper
public struct UserDefault<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let storage: UserDefaultsStorage
    
    /// 초기화
    /// - Parameters:
    ///   - key: 저장 키
    ///   - defaultValue: 기본값
    ///   - suiteName: Suite 이름 (App Groups 사용 시)
    public init(
        key: String,
        defaultValue: T,
        suiteName: String? = nil
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = UserDefaultsStorage(suiteName: suiteName)
    }
    
    public var wrappedValue: T {
        get {
            (try? storage.load(forKey: key)) ?? defaultValue
        }
        set {
            try? storage.save(newValue, forKey: key)
        }
    }
}


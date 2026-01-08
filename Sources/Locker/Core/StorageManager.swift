//
//  StorageManager.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 통합 스토리지 매니저 (Facade Pattern)
public final class StorageManager {
    /// 공유 인스턴스
    public static let shared = StorageManager()
    
    private let keychainStorage: KeychainStorage
    private let userDefaultsStorage: UserDefaultsStorage
    private let configuration: StorageConfiguration
    
    /// 초기화
    /// - Parameter configuration: 스토리지 설정
    public init(configuration: StorageConfiguration = .default) {
        self.configuration = configuration
        self.keychainStorage = KeychainStorage(
            service: configuration.keychainService,
            accessGroup: configuration.keychainAccessGroup
        )
        self.userDefaultsStorage = UserDefaultsStorage(
            suiteName: configuration.userDefaultsSuite
        )
        
        if configuration.enableDebugLogging {
            StorageLogger.shared.enable()
        }
    }
    
    // MARK: - Keychain (민감 정보)
    
    /// Keychain에 안전하게 저장
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 저장 키
    ///   - accessibility: 접근성 옵션
    /// - Throws: StorageError
    public func saveSecure<T: Codable>(
        _ value: T,
        forKey key: String,
        accessibility: KeychainAccessibility = .afterFirstUnlock
    ) throws {
        try keychainStorage.save(value, forKey: key, accessibility: accessibility)
        StorageLogger.shared.log("Keychain에 저장됨: \(key)")
    }
    
    /// Keychain에서 조회
    /// - Parameter key: 조회 키
    /// - Returns: 저장된 값
    /// - Throws: StorageError
    public func loadSecure<T: Codable>(forKey key: String) throws -> T? {
        let value: T? = try keychainStorage.load(forKey: key)
        StorageLogger.shared.log("Keychain에서 조회: \(key) - \(value != nil ? "성공" : "없음")")
        return value
    }
    
    /// Keychain에서 삭제
    /// - Parameter key: 삭제할 키
    /// - Throws: StorageError
    public func deleteSecure(forKey key: String) throws {
        try keychainStorage.delete(forKey: key)
        StorageLogger.shared.log("Keychain에서 삭제됨: \(key)")
    }
    
    /// Keychain에 존재하는지 확인
    /// - Parameter key: 확인할 키
    /// - Returns: 존재 여부
    public func existsInSecure(forKey key: String) -> Bool {
        return keychainStorage.exists(forKey: key)
    }
    
    // MARK: - UserDefaults (일반 설정)
    
    /// UserDefaults에 저장
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 저장 키
    /// - Throws: StorageError
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        try userDefaultsStorage.save(value, forKey: key)
        StorageLogger.shared.log("UserDefaults에 저장됨: \(key)")
    }
    
    /// UserDefaults에서 조회
    /// - Parameter key: 조회 키
    /// - Returns: 저장된 값
    /// - Throws: StorageError
    public func load<T: Codable>(forKey key: String) throws -> T? {
        let value: T? = try userDefaultsStorage.load(forKey: key)
        StorageLogger.shared.log("UserDefaults에서 조회: \(key) - \(value != nil ? "성공" : "없음")")
        return value
    }
    
    /// UserDefaults에서 삭제
    /// - Parameter key: 삭제할 키
    /// - Throws: StorageError
    public func delete(forKey key: String) throws {
        try userDefaultsStorage.delete(forKey: key)
        StorageLogger.shared.log("UserDefaults에서 삭제됨: \(key)")
    }
    
    /// UserDefaults에 존재하는지 확인
    /// - Parameter key: 확인할 키
    /// - Returns: 존재 여부
    public func exists(forKey key: String) -> Bool {
        return userDefaultsStorage.exists(forKey: key)
    }
    
    // MARK: - 전체 삭제
    
    /// 모든 Keychain 데이터 삭제
    /// - Throws: StorageError
    public func deleteAllSecure() throws {
        try keychainStorage.deleteAll()
        StorageLogger.shared.log("모든 Keychain 데이터 삭제됨")
    }
    
    /// 모든 UserDefaults 데이터 삭제
    /// - Throws: StorageError
    public func deleteAll() throws {
        try userDefaultsStorage.deleteAll()
        StorageLogger.shared.log("모든 UserDefaults 데이터 삭제됨")
    }
}


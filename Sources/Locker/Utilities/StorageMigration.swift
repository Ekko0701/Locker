//
//  StorageMigration.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 스토리지 마이그레이션 관리
public struct StorageMigration {
    
    /// UserDefaults 키 마이그레이션
    /// - Parameters:
    ///   - oldKey: 기존 키
    ///   - newKey: 새 키
    ///   - deleteOldKey: 기존 키 삭제 여부
    /// - Throws: StorageError
    public static func migrate(
        from oldKey: String,
        to newKey: String,
        deleteOldKey: Bool = true
    ) throws {
        let userDefaults = UserDefaults.standard
        
        // 기존 값이 있는지 확인
        guard let value = userDefaults.object(forKey: oldKey) else {
            // 기존 값이 없으면 마이그레이션 불필요
            return
        }
        
        // 새 키로 저장
        userDefaults.set(value, forKey: newKey)
        
        // 기존 키 삭제
        if deleteOldKey {
            userDefaults.removeObject(forKey: oldKey)
        }
        
        userDefaults.synchronize()
        StorageLogger.shared.log("마이그레이션 완료: \(oldKey) → \(newKey)")
    }
    
    /// UserDefaults에서 Keychain으로 마이그레이션
    /// - Parameters:
    ///   - key: 마이그레이션할 키
    ///   - service: Keychain 서비스 이름
    ///   - deleteAfterMigration: 마이그레이션 후 원본 삭제 여부
    /// - Throws: StorageError
    public static func migrateToKeychain(
        key: String,
        service: String = Bundle.main.bundleIdentifier ?? "com.locker.storage",
        deleteAfterMigration: Bool = true
    ) throws {
        let userDefaults = UserDefaults.standard
        let keychain = KeychainStorage(service: service)
        
        // UserDefaults에서 값 조회
        guard let value = userDefaults.object(forKey: key) else {
            // 값이 없으면 마이그레이션 불필요
            return
        }
        
        // 값을 Data로 변환
        let data: Data
        if let dataValue = value as? Data {
            data = dataValue
        } else if let stringValue = value as? String {
            guard let stringData = stringValue.data(using: .utf8) else {
                throw StorageError.encodingFailed(NSError(domain: "Locker", code: -1, userInfo: [NSLocalizedDescriptionKey: "String을 Data로 변환할 수 없습니다"]))
            }
            data = stringData
        } else {
            // 기타 객체는 NSKeyedArchiver로 처리
            if #available(macOS 10.13, iOS 11.0, tvOS 11.0, watchOS 4.0, *) {
                data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
            } else {
                data = NSKeyedArchiver.archivedData(withRootObject: value)
            }
        }
        
        // Keychain으로 이동
        try keychain.save(data, forKey: key)
        
        // 원본 삭제
        if deleteAfterMigration {
            userDefaults.removeObject(forKey: key)
            userDefaults.synchronize()
        }
        
        StorageLogger.shared.log("Keychain으로 마이그레이션 완료: \(key)")
    }
    
    /// Keychain에서 UserDefaults로 마이그레이션 (일반적으로 비권장)
    /// - Parameters:
    ///   - key: 마이그레이션할 키
    ///   - service: Keychain 서비스 이름
    ///   - deleteAfterMigration: 마이그레이션 후 원본 삭제 여부
    /// - Throws: StorageError
    public static func migrateToUserDefaults(
        key: String,
        service: String = Bundle.main.bundleIdentifier ?? "com.locker.storage",
        deleteAfterMigration: Bool = true
    ) throws {
        let keychain = KeychainStorage(service: service)
        let userDefaults = UserDefaultsStorage()
        
        // Keychain에서 값 조회
        guard let value: Data = try keychain.load(forKey: key) else {
            // 값이 없으면 마이그레이션 불필요
            return
        }
        
        // UserDefaults로 이동
        try userDefaults.save(value, forKey: key)
        
        // 원본 삭제
        if deleteAfterMigration {
            try keychain.delete(forKey: key)
        }
        
        StorageLogger.shared.log("UserDefaults로 마이그레이션 완료: \(key)")
    }
    
    /// 배치 마이그레이션
    /// - Parameters:
    ///   - migrations: 마이그레이션할 키 쌍 배열 [(oldKey, newKey)]
    ///   - deleteOldKeys: 기존 키 삭제 여부
    /// - Throws: StorageError
    public static func batchMigrate(
        migrations: [(oldKey: String, newKey: String)],
        deleteOldKeys: Bool = true
    ) throws {
        for (oldKey, newKey) in migrations {
            try migrate(from: oldKey, to: newKey, deleteOldKey: deleteOldKeys)
        }
    }
}


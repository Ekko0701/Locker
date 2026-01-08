//
//  StorageMigrationTests.swift
//  LockerTests
//
//  Created by 김동주 on 2026. 1. 8.
//

import XCTest
@testable import Locker

final class StorageMigrationTests: XCTestCase {
    var storage: UserDefaultsStorage!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsStorage()
    }
    
    override func tearDown() {
        try? storage.deleteAll()
        super.tearDown()
    }
    
    // MARK: - Key Migration Tests
    
    func testMigrateKey() throws {
        // Given
        let oldKey = "old.key"
        let newKey = "new.key"
        let testValue = "TestValue"
        
        try storage.save(testValue, forKey: oldKey)
        
        // When
        try StorageMigration.migrate(from: oldKey, to: newKey)
        
        // Then
        let oldValue: String? = try storage.load(forKey: oldKey)
        let newValue: String? = try storage.load(forKey: newKey)
        
        XCTAssertNil(oldValue) // 기존 키는 삭제됨
        XCTAssertEqual(testValue, newValue) // 새 키에 값 존재
    }
    
    func testMigrateKeyWithoutDeletion() throws {
        // Given
        let oldKey = "old.key"
        let newKey = "new.key"
        let testValue = "TestValue"
        
        try storage.save(testValue, forKey: oldKey)
        
        // When
        try StorageMigration.migrate(from: oldKey, to: newKey, deleteOldKey: false)
        
        // Then
        let oldValue: String? = try storage.load(forKey: oldKey)
        let newValue: String? = try storage.load(forKey: newKey)
        
        XCTAssertEqual(testValue, oldValue) // 기존 키 유지
        XCTAssertEqual(testValue, newValue) // 새 키에 값 복사
    }
    
    // MARK: - Keychain Migration Tests
    
    func testMigrateToKeychain() throws {
        // Given
        let key = "sensitiveData"
        let testValue = "SecretValue"
        let service = "com.locker.test"
        
        try storage.save(testValue, forKey: key)
        
        // When
        try StorageMigration.migrateToKeychain(key: key, service: service)
        
        // Then
        let userDefaultsValue: String? = try storage.load(forKey: key)
        
        let keychain = KeychainStorage(service: service)
        // Data로 로드한 후 String으로 변환
        let keychainData: Data? = try keychain.load(forKey: key)
        let keychainValue = keychainData.flatMap { String(data: $0, encoding: .utf8) }
        
        XCTAssertNil(userDefaultsValue) // UserDefaults에서 삭제됨
        XCTAssertEqual(testValue, keychainValue) // Keychain에 저장됨
        
        // Cleanup
        try? keychain.delete(forKey: key)
    }
    
    // MARK: - Batch Migration Tests
    
    func testBatchMigration() throws {
        // Given
        let migrations = [
            (oldKey: "old.key1", newKey: "new.key1"),
            (oldKey: "old.key2", newKey: "new.key2"),
            (oldKey: "old.key3", newKey: "new.key3")
        ]
        
        try storage.save("value1", forKey: "old.key1")
        try storage.save("value2", forKey: "old.key2")
        try storage.save("value3", forKey: "old.key3")
        
        // When
        try StorageMigration.batchMigrate(migrations: migrations)
        
        // Then
        let newValue1: String? = try storage.load(forKey: "new.key1")
        let newValue2: String? = try storage.load(forKey: "new.key2")
        let newValue3: String? = try storage.load(forKey: "new.key3")
        
        XCTAssertEqual("value1", newValue1)
        XCTAssertEqual("value2", newValue2)
        XCTAssertEqual("value3", newValue3)
    }
}


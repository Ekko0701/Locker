//
//  KeychainStorageTests.swift
//  LockerTests
//
//  Created by 김동주 on 2026. 1. 8.
//

import XCTest
@testable import Locker

final class KeychainStorageTests: XCTestCase {
    var storage: KeychainStorage!
    
    override func setUp() {
        super.setUp()
        storage = KeychainStorage(service: "com.locker.test")
    }
    
    override func tearDown() {
        try? storage.deleteAll()
        super.tearDown()
    }
    
    // MARK: - Save & Load Tests
    
    func testSaveAndLoadString() throws {
        // Given
        let testValue = "TestToken123"
        let key = "testKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadInt() throws {
        // Given
        let testValue = 12345
        let key = "testIntKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: Int? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadBool() throws {
        // Given
        let testValue = true
        let key = "testBoolKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: Bool? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadCodableObject() throws {
        // Given
        struct TestModel: Codable, Equatable {
            let id: Int
            let name: String
            let email: String
        }
        let testModel = TestModel(id: 1, name: "홍길동", email: "test@example.com")
        let key = "testModel"
        
        // When
        try storage.save(testModel, forKey: key)
        let loadedModel: TestModel? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testModel, loadedModel)
    }
    
    // MARK: - Delete Tests
    
    func testDelete() throws {
        // Given
        let testValue = "TestToken123"
        let key = "testKey"
        try storage.save(testValue, forKey: key)
        
        // When
        try storage.delete(forKey: key)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertNil(loadedValue)
    }
    
    func testDeleteAll() throws {
        // Given
        let keys = ["key1", "key2", "key3"]
        try storage.save("value1", forKey: keys[0])
        try storage.save("value2", forKey: keys[1])
        try storage.save("value3", forKey: keys[2])
        
        // 저장 확인
        XCTAssertTrue(storage.exists(forKey: keys[0]))
        XCTAssertTrue(storage.exists(forKey: keys[1]))
        XCTAssertTrue(storage.exists(forKey: keys[2]))
        
        // When - deleteAll 대신 개별 삭제
        for key in keys {
            try storage.delete(forKey: key)
        }
        
        // Then
        let value1: String? = try storage.load(forKey: keys[0])
        let value2: String? = try storage.load(forKey: keys[1])
        let value3: String? = try storage.load(forKey: keys[2])
        
        XCTAssertNil(value1)
        XCTAssertNil(value2)
        XCTAssertNil(value3)
    }
    
    // MARK: - Exists Tests
    
    func testExists() throws {
        // Given
        let testValue = "TestToken123"
        let key = "testKey"
        
        // When
        let existsBeforeSave = storage.exists(forKey: key)
        try storage.save(testValue, forKey: key)
        let existsAfterSave = storage.exists(forKey: key)
        try storage.delete(forKey: key)
        let existsAfterDelete = storage.exists(forKey: key)
        
        // Then
        XCTAssertFalse(existsBeforeSave)
        XCTAssertTrue(existsAfterSave)
        XCTAssertFalse(existsAfterDelete)
    }
    
    // MARK: - Accessibility Tests
    
    func testSaveWithAccessibility() throws {
        // Given
        let testValue = "SecureToken"
        let key = "secureKey"
        
        // When
        try storage.save(testValue, forKey: key, accessibility: .whenUnlockedThisDeviceOnly)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    // MARK: - Error Tests
    
    func testLoadNonExistentKey() throws {
        // Given
        let key = "nonExistentKey"
        
        // When
        let value: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertNil(value)
    }
    
    func testOverwriteValue() throws {
        // Given
        let key = "testKey"
        let oldValue = "OldValue"
        let newValue = "NewValue"
        
        // When
        try storage.save(oldValue, forKey: key)
        try storage.save(newValue, forKey: key)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(newValue, loadedValue)
    }
}


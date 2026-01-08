//
//  UserDefaultsStorageTests.swift
//  LockerTests
//
//  Created by 김동주 on 2026. 1. 8.
//

import XCTest
@testable import Locker

final class UserDefaultsStorageTests: XCTestCase {
    var storage: UserDefaultsStorage!
    
    override func setUp() {
        super.setUp()
        storage = UserDefaultsStorage()
    }
    
    override func tearDown() {
        try? storage.deleteAll()
        super.tearDown()
    }
    
    // MARK: - Save & Load Tests
    
    func testSaveAndLoadString() throws {
        // Given
        let testValue = "TestString"
        let key = "testStringKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadInt() throws {
        // Given
        let testValue = 42
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
    
    func testSaveAndLoadDouble() throws {
        // Given
        let testValue = 3.14159
        let key = "testDoubleKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: Double? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadData() throws {
        // Given
        let testValue = "TestData".data(using: .utf8)!
        let key = "testDataKey"
        
        // When
        try storage.save(testValue, forKey: key)
        let loadedValue: Data? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testValue, loadedValue)
    }
    
    func testSaveAndLoadCodableObject() throws {
        // Given
        struct TestUser: Codable, Equatable {
            let id: Int
            let name: String
            let age: Int
        }
        let testUser = TestUser(id: 1, name: "김철수", age: 25)
        let key = "testUser"
        
        // When
        try storage.save(testUser, forKey: key)
        let loadedUser: TestUser? = try storage.load(forKey: key)
        
        // Then
        XCTAssertEqual(testUser, loadedUser)
    }
    
    // MARK: - Delete Tests
    
    func testDelete() throws {
        // Given
        let testValue = "TestValue"
        let key = "testKey"
        try storage.save(testValue, forKey: key)
        
        // When
        try storage.delete(forKey: key)
        let loadedValue: String? = try storage.load(forKey: key)
        
        // Then
        XCTAssertNil(loadedValue)
    }
    
    // MARK: - Exists Tests
    
    func testExists() throws {
        // Given
        let testValue = "TestValue"
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


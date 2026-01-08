//
//  StorageManagerTests.swift
//  LockerTests
//
//  Created by 김동주 on 2026. 1. 8.
//

import XCTest
@testable import Locker

final class StorageManagerTests: XCTestCase {
    var manager: StorageManager!
    
    override func setUp() {
        super.setUp()
        let config = StorageConfiguration(
            keychainService: "com.locker.test",
            enableDebugLogging: true
        )
        manager = StorageManager(configuration: config)
    }
    
    override func tearDown() {
        try? manager.deleteAllSecure()
        try? manager.deleteAll()
        super.tearDown()
    }
    
    // MARK: - Keychain Tests
    
    func testSaveAndLoadSecure() throws {
        // Given
        let token = "SecureToken123"
        let key = "accessToken"
        
        // When
        try manager.saveSecure(token, forKey: key)
        let loadedToken: String? = try manager.loadSecure(forKey: key)
        
        // Then
        XCTAssertEqual(token, loadedToken)
    }
    
    func testDeleteSecure() throws {
        // Given
        let token = "SecureToken123"
        let key = "accessToken"
        try manager.saveSecure(token, forKey: key)
        
        // When
        try manager.deleteSecure(forKey: key)
        let loadedToken: String? = try manager.loadSecure(forKey: key)
        
        // Then
        XCTAssertNil(loadedToken)
    }
    
    func testExistsInSecure() throws {
        // Given
        let token = "SecureToken123"
        let key = "accessToken"
        
        // When
        let existsBefore = manager.existsInSecure(forKey: key)
        try manager.saveSecure(token, forKey: key)
        let existsAfter = manager.existsInSecure(forKey: key)
        
        // Then
        XCTAssertFalse(existsBefore)
        XCTAssertTrue(existsAfter)
    }
    
    // MARK: - UserDefaults Tests
    
    func testSaveAndLoad() throws {
        // Given
        let isDarkMode = true
        let key = "isDarkMode"
        
        // When
        try manager.save(isDarkMode, forKey: key)
        let loadedValue: Bool? = try manager.load(forKey: key)
        
        // Then
        XCTAssertEqual(isDarkMode, loadedValue)
    }
    
    func testDelete() throws {
        // Given
        let isDarkMode = true
        let key = "isDarkMode"
        try manager.save(isDarkMode, forKey: key)
        
        // When
        try manager.delete(forKey: key)
        let loadedValue: Bool? = try manager.load(forKey: key)
        
        // Then
        XCTAssertNil(loadedValue)
    }
    
    func testExists() throws {
        // Given
        let value = "TestValue"
        let key = "testKey"
        
        // When
        let existsBefore = manager.exists(forKey: key)
        try manager.save(value, forKey: key)
        let existsAfter = manager.exists(forKey: key)
        
        // Then
        XCTAssertFalse(existsBefore)
        XCTAssertTrue(existsAfter)
    }
    
    // MARK: - Complex Object Tests
    
    func testSaveAndLoadComplexObject() throws {
        // Given
        struct UserProfile: Codable, Equatable {
            let id: Int
            let name: String
            let email: String
            let preferences: [String: String]
        }
        
        let profile = UserProfile(
            id: 123,
            name: "김동주",
            email: "test@example.com",
            preferences: ["theme": "dark", "language": "ko"]
        )
        let key = "userProfile"
        
        // When
        try manager.save(profile, forKey: key)
        let loadedProfile: UserProfile? = try manager.load(forKey: key)
        
        // Then
        XCTAssertEqual(profile, loadedProfile)
    }
    
    // MARK: - Mixed Storage Tests
    
    func testMixedStorageUsage() throws {
        // Given
        let token = "SecureToken123"
        let isDarkMode = true
        
        // When
        try manager.saveSecure(token, forKey: "accessToken")
        try manager.save(isDarkMode, forKey: "isDarkMode")
        
        let loadedToken: String? = try manager.loadSecure(forKey: "accessToken")
        let loadedDarkMode: Bool? = try manager.load(forKey: "isDarkMode")
        
        // Then
        XCTAssertEqual(token, loadedToken)
        XCTAssertEqual(isDarkMode, loadedDarkMode)
    }
}


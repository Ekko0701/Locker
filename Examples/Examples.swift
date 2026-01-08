//
//  Examples.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//  
//  이 파일은 Locker의 다양한 사용 예시를 보여줍니다.
//

import Foundation
import Locker

// MARK: - 기본 사용 예시

func basicUsageExample() {
    do {
        // Keychain에 토큰 저장
        try StorageManager.shared.saveSecure("myAccessToken", forKey: "accessToken")
        
        // Keychain에서 토큰 로드
        if let token: String = try StorageManager.shared.loadSecure(forKey: "accessToken") {
            print("Token: \(token)")
        }
        
        // UserDefaults에 설정 저장
        try StorageManager.shared.save(true, forKey: "isDarkMode")
        
        // UserDefaults에서 설정 로드
        if let isDarkMode: Bool = try StorageManager.shared.load(forKey: "isDarkMode") {
            print("Dark Mode: \(isDarkMode)")
        }
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - Codable 객체 저장

struct User: Codable {
    let id: Int
    let name: String
    let email: String
}

func codableObjectExample() {
    do {
        let user = User(id: 1, name: "김동주", email: "user@example.com")
        
        // 저장
        try StorageManager.shared.save(user, forKey: "currentUser")
        
        // 로드
        if let loadedUser: User = try StorageManager.shared.load(forKey: "currentUser") {
            print("User: \(loadedUser.name)")
        }
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - PropertyWrapper 사용

class AppSettings {
    @UserDefault(key: "theme", defaultValue: "light")
    var theme: String
    
    @UserDefault(key: "fontSize", defaultValue: 14.0)
    var fontSize: Double
    
    @UserDefault(key: "notificationsEnabled", defaultValue: true)
    var notificationsEnabled: Bool
}

func propertyWrapperExample() {
    let settings = AppSettings()
    
    // 자동으로 UserDefaults에 저장됨
    settings.theme = "dark"
    settings.fontSize = 16.0
    settings.notificationsEnabled = false
    
    // 자동으로 UserDefaults에서 로드됨
    print("Theme: \(settings.theme)")
    print("Font Size: \(settings.fontSize)")
    print("Notifications: \(settings.notificationsEnabled)")
}

// MARK: - App Groups 사용

func appGroupsExample() {
    let config = StorageConfiguration(
        keychainService: "com.myapp.shared",
        keychainAccessGroup: "group.com.myapp.shared",
        userDefaultsSuite: "group.com.myapp.shared"
    )
    
    let sharedManager = StorageManager(configuration: config)
    
    do {
        // 앱과 Extension 간 공유 데이터
        try sharedManager.save(42, forKey: "unreadCount")
        
        if let count: Int = try sharedManager.load(forKey: "unreadCount") {
            print("Unread Count: \(count)")
        }
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - 마이그레이션

func migrationExample() {
    do {
        // 키 이름 변경
        try StorageMigration.migrate(from: "oldKey", to: "newKey")
        
        // UserDefaults에서 Keychain으로 민감 정보 마이그레이션
        try StorageMigration.migrateToKeychain(key: "authToken")
        
        // 배치 마이그레이션
        try StorageMigration.batchMigrate(migrations: [
            (oldKey: "user_name", newKey: "userName"),
            (oldKey: "user_email", newKey: "userEmail")
        ])
    } catch {
        print("Migration Error: \(error)")
    }
}

// MARK: - 배치 작업

func batchOperationsExample() {
    let storage = UserDefaultsStorage()
    
    do {
        // 여러 값 한번에 저장
        try storage.saveBatch([
            "key1": "value1",
            "key2": "value2",
            "key3": "value3"
        ])
        
        // 여러 값 한번에 조회
        let values: [String: String?] = try storage.loadBatch(keys: ["key1", "key2", "key3"])
        print("Values: \(values)")
        
        // 여러 키 한번에 삭제
        try storage.deleteBatch(keys: ["key1", "key2", "key3"])
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - 에러 핸들링

func errorHandlingExample() {
    do {
        try StorageManager.shared.saveSecure("myToken", forKey: "token")
    } catch StorageError.keychainError(let status) {
        print("Keychain Error: \(status)")
    } catch StorageError.encodingFailed(let error) {
        print("Encoding Error: \(error)")
    } catch StorageError.accessDenied {
        print("Access Denied")
    } catch {
        print("Unknown Error: \(error)")
    }
}

// MARK: - 디버깅

func debuggingExample() {
    // 로깅 활성화
    StorageLogger.shared.enable()
    
    // 모든 UserDefaults 출력
    StorageLogger.shared.printAllUserDefaults()
    
    // 특정 Suite 출력
    StorageLogger.shared.printUserDefaults(suiteName: "group.com.myapp.shared")
}

// MARK: - 접근성 옵션

func accessibilityExample() {
    do {
        // 디바이스 잠금 해제 후 접근 가능
        try StorageManager.shared.saveSecure(
            "normalToken",
            forKey: "token",
            accessibility: .afterFirstUnlock
        )
        
        // 디바이스 잠금 해제 시에만 접근 (백업 안됨)
        try StorageManager.shared.saveSecure(
            "sensitivePassword",
            forKey: "password",
            accessibility: .whenUnlockedThisDeviceOnly
        )
        
        // 패스코드 설정 시에만 접근 (생체 인증)
        try StorageManager.shared.saveSecure(
            "biometricToken",
            forKey: "biometric",
            accessibility: .whenPasscodeSetThisDeviceOnly
        )
    } catch {
        print("Error: \(error)")
    }
}

// MARK: - 실제 사용 시나리오

class AuthenticationManager {
    private let storage = StorageManager.shared
    
    func login(accessToken: String, refreshToken: String) throws {
        // 민감한 토큰은 Keychain에 저장
        try storage.saveSecure(accessToken, forKey: "accessToken")
        try storage.saveSecure(refreshToken, forKey: "refreshToken")
        
        // 로그인 상태는 UserDefaults에 저장
        try storage.save(true, forKey: "isLoggedIn")
        try storage.save(Date(), forKey: "lastLoginDate")
    }
    
    func logout() throws {
        // 모든 인증 정보 삭제
        try storage.deleteSecure(forKey: "accessToken")
        try storage.deleteSecure(forKey: "refreshToken")
        try storage.delete(forKey: "isLoggedIn")
    }
    
    func getAccessToken() throws -> String? {
        return try storage.loadSecure(forKey: "accessToken")
    }
    
    func isLoggedIn() -> Bool {
        return (try? storage.load(forKey: "isLoggedIn")) ?? false
    }
}


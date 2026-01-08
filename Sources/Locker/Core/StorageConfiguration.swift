//
//  StorageConfiguration.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 스토리지 설정
public struct StorageConfiguration {
    /// Keychain 서비스 이름
    public let keychainService: String
    
    /// Keychain 접근 그룹 (App Groups 사용 시)
    public let keychainAccessGroup: String?
    
    /// UserDefaults Suite 이름 (App Groups 사용 시)
    public let userDefaultsSuite: String?
    
    /// 디버그 로깅 활성화 여부
    public let enableDebugLogging: Bool
    
    public init(
        keychainService: String = Bundle.main.bundleIdentifier ?? "com.locker.storage",
        keychainAccessGroup: String? = nil,
        userDefaultsSuite: String? = nil,
        enableDebugLogging: Bool = false
    ) {
        self.keychainService = keychainService
        self.keychainAccessGroup = keychainAccessGroup
        self.userDefaultsSuite = userDefaultsSuite
        self.enableDebugLogging = enableDebugLogging
    }
    
    /// 기본 설정
    public static var `default`: StorageConfiguration {
        return StorageConfiguration()
    }
}


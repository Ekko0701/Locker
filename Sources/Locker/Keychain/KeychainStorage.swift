//
//  KeychainStorage.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Security

/// Keychain 스토리지 구현
public final class KeychainStorage: StorageProtocol {
    private let service: String
    private let accessGroup: String?
    
    /// 초기화
    /// - Parameters:
    ///   - service: Keychain 서비스 이름
    ///   - accessGroup: 접근 그룹 (App Groups 사용 시)
    public init(
        service: String,
        accessGroup: String? = nil
    ) {
        self.service = service
        self.accessGroup = accessGroup
    }
    
    /// 값 저장
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        try save(value, forKey: key, accessibility: .afterFirstUnlock)
    }
    
    /// 값 저장 (접근성 옵션 지정)
    /// - Parameters:
    ///   - value: 저장할 값
    ///   - key: 저장 키
    ///   - accessibility: 접근성 옵션
    public func save<T: Codable>(
        _ value: T,
        forKey key: String,
        accessibility: KeychainAccessibility
    ) throws {
        let encoder = JSONEncoder()
        let data: Data
        
        do {
            data = try encoder.encode(value)
        } catch {
            throw StorageError.encodingFailed(error)
        }
        
        var query = buildQuery(forKey: key)
        query[kSecValueData as String] = data
        query[kSecAttrAccessible as String] = accessibility.attributeValue
        
        // 기존 항목 삭제 후 추가
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.keychainError(status)
        }
    }
    
    /// 값 조회
    public func load<T: Codable>(forKey key: String) throws -> T? {
        var query = buildQuery(forKey: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            return nil
        }
        
        guard status == errSecSuccess else {
            throw StorageError.keychainError(status)
        }
        
        guard let data = result as? Data else {
            throw StorageError.invalidData
        }
        
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw StorageError.decodingFailed(error)
        }
    }
    
    /// 값 삭제
    public func delete(forKey key: String) throws {
        let query = buildQuery(forKey: key)
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw StorageError.keychainError(status)
        }
    }
    
    /// 모든 값 삭제
    public func deleteAll() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw StorageError.keychainError(status)
        }
    }
    
    /// 키 존재 여부 확인
    public func exists(forKey key: String) -> Bool {
        var query = buildQuery(forKey: key)
        query[kSecReturnData as String] = false
        
        let status = SecItemCopyMatching(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Private Methods
    
    private func buildQuery(forKey key: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        return query
    }
}


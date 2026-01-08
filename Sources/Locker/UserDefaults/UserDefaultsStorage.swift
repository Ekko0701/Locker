//
//  UserDefaultsStorage.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// UserDefaults 스토리지 구현
public final class UserDefaultsStorage: StorageProtocol {
    private let userDefaults: UserDefaults
    
    /// 초기화
    /// - Parameter suiteName: Suite 이름 (App Groups 사용 시)
    public init(suiteName: String? = nil) {
        if let suiteName = suiteName {
            self.userDefaults = UserDefaults(suiteName: suiteName) ?? .standard
        } else {
            self.userDefaults = .standard
        }
    }
    
    /// 값 저장
    public func save<T: Codable>(_ value: T, forKey key: String) throws {
        // 기본 타입 최적화
        if let data = value as? Data {
            userDefaults.set(data, forKey: key)
        } else if let string = value as? String {
            userDefaults.set(string, forKey: key)
        } else if let number = value as? NSNumber {
            userDefaults.set(number, forKey: key)
        } else if let bool = value as? Bool {
            userDefaults.set(bool, forKey: key)
        } else if let int = value as? Int {
            userDefaults.set(int, forKey: key)
        } else if let double = value as? Double {
            userDefaults.set(double, forKey: key)
        } else if let float = value as? Float {
            userDefaults.set(float, forKey: key)
        } else {
            // Codable 객체는 JSON으로 인코딩
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(value)
                userDefaults.set(data, forKey: key)
            } catch {
                throw StorageError.encodingFailed(error)
            }
        }
        
        userDefaults.synchronize()
    }
    
    /// 값 조회
    public func load<T: Codable>(forKey key: String) throws -> T? {
        // 기본 타입 처리
        if T.self == String.self {
            return userDefaults.string(forKey: key) as? T
        } else if T.self == Int.self {
            guard userDefaults.object(forKey: key) != nil else { return nil }
            return userDefaults.integer(forKey: key) as? T
        } else if T.self == Bool.self {
            guard userDefaults.object(forKey: key) != nil else { return nil }
            return userDefaults.bool(forKey: key) as? T
        } else if T.self == Double.self {
            guard userDefaults.object(forKey: key) != nil else { return nil }
            return userDefaults.double(forKey: key) as? T
        } else if T.self == Float.self {
            guard userDefaults.object(forKey: key) != nil else { return nil }
            return userDefaults.float(forKey: key) as? T
        } else if T.self == Data.self {
            return userDefaults.data(forKey: key) as? T
        }
        
        // Codable 객체 디코딩
        guard let data = userDefaults.data(forKey: key) else {
            return nil
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
        userDefaults.removeObject(forKey: key)
        userDefaults.synchronize()
    }
    
    /// 모든 값 삭제
    public func deleteAll() throws {
        if let bundleID = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: bundleID)
        }
        userDefaults.synchronize()
    }
    
    /// 키 존재 여부 확인
    public func exists(forKey key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}


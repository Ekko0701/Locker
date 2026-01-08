//
//  StorageProtocol+Batch.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

extension StorageProtocol {
    /// 여러 값을 한번에 저장
    /// - Parameter items: 저장할 키-값 딕셔너리
    /// - Throws: StorageError
    public func saveBatch<T: Codable>(_ items: [String: T]) throws {
        for (key, value) in items {
            try save(value, forKey: key)
        }
    }
    
    /// 여러 키를 한번에 삭제
    /// - Parameter keys: 삭제할 키 배열
    /// - Throws: StorageError
    public func deleteBatch(keys: [String]) throws {
        for key in keys {
            try delete(forKey: key)
        }
    }
    
    /// 여러 값을 한번에 조회
    /// - Parameter keys: 조회할 키 배열
    /// - Returns: 키-값 딕셔너리
    /// - Throws: StorageError
    public func loadBatch<T: Codable>(keys: [String]) throws -> [String: T?] {
        var result: [String: T?] = [:]
        for key in keys {
            result[key] = try load(forKey: key)
        }
        return result
    }
}


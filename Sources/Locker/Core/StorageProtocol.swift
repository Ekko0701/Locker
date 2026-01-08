//
//  StorageProtocol.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 모든 스토리지가 준수할 기본 프로토콜
public protocol StorageProtocol {
    /// 값 저장
    /// - Parameters:
    ///   - value: 저장할 Codable 값
    ///   - key: 저장 키
    /// - Throws: StorageError
    func save<T: Codable>(_ value: T, forKey key: String) throws
    
    /// 값 조회
    /// - Parameter key: 조회 키
    /// - Returns: 저장된 값 (없으면 nil)
    /// - Throws: StorageError
    func load<T: Codable>(forKey key: String) throws -> T?
    
    /// 값 삭제
    /// - Parameter key: 삭제할 키
    /// - Throws: StorageError
    func delete(forKey key: String) throws
    
    /// 모든 값 삭제
    /// - Throws: StorageError
    func deleteAll() throws
    
    /// 키 존재 여부 확인
    /// - Parameter key: 확인할 키
    /// - Returns: 존재 여부
    func exists(forKey key: String) -> Bool
}


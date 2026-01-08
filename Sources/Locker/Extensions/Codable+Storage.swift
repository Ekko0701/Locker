//
//  Codable+Storage.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

extension Encodable {
    /// Codable 객체를 JSON Data로 변환
    /// - Returns: JSON Data
    /// - Throws: EncodingError
    func toJSONData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try encoder.encode(self)
    }
    
    /// Codable 객체를 JSON String으로 변환
    /// - Returns: JSON String
    /// - Throws: EncodingError
    func toJSONString() throws -> String {
        let data = try toJSONData()
        guard let string = String(data: data, encoding: .utf8) else {
            throw StorageError.encodingFailed(NSError(domain: "Locker", code: -1))
        }
        return string
    }
}

extension Data {
    /// JSON Data를 Codable 객체로 변환
    /// - Parameter type: 변환할 타입
    /// - Returns: Codable 객체
    /// - Throws: DecodingError
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: self)
    }
}

extension String {
    /// JSON String을 Codable 객체로 변환
    /// - Parameter type: 변환할 타입
    /// - Returns: Codable 객체
    /// - Throws: DecodingError
    func toObject<T: Decodable>(_ type: T.Type) throws -> T {
        guard let data = self.data(using: .utf8) else {
            throw StorageError.decodingFailed(NSError(domain: "Locker", code: -1))
        }
        return try data.toObject(type)
    }
}


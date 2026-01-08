//
//  StorageError.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 스토리지 관련 에러
public enum StorageError: LocalizedError {
    case itemNotFound(key: String)
    case encodingFailed(Error)
    case decodingFailed(Error)
    case keychainError(OSStatus)
    case accessDenied
    case invalidData
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
        case .itemNotFound(let key):
            return "항목을 찾을 수 없습니다: \(key)"
        case .encodingFailed(let error):
            return "인코딩 실패: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "디코딩 실패: \(error.localizedDescription)"
        case .keychainError(let status):
            return "Keychain 오류 (코드: \(status))"
        case .accessDenied:
            return "접근이 거부되었습니다"
        case .invalidData:
            return "잘못된 데이터 형식입니다"
        case .unknown(let error):
            return "알 수 없는 오류: \(error.localizedDescription)"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .itemNotFound:
            return "저장된 값이 있는지 확인하세요"
        case .keychainError:
            return "디바이스 잠금을 해제하거나 앱을 재시작하세요"
        case .accessDenied:
            return "필요한 권한을 확인하세요"
        default:
            return nil
        }
    }
}


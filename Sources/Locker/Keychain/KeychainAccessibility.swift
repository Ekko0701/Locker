//
//  KeychainAccessibility.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Security

/// Keychain 접근성 옵션
public enum KeychainAccessibility {
    /// 디바이스 잠금 해제 후 첫 접근 이후 계속 접근 가능 (기본값)
    case afterFirstUnlock
    
    /// 디바이스 잠금 해제 후 첫 접근 이후 계속 접근 가능 (백업 안됨)
    case afterFirstUnlockThisDeviceOnly
    
    /// 디바이스 잠금 해제 시에만 접근 가능
    case whenUnlocked
    
    /// 디바이스 잠금 해제 시에만 접근 가능 (백업 안됨)
    case whenUnlockedThisDeviceOnly
    
    /// 패스코드 설정 시에만 접근 가능
    case whenPasscodeSetThisDeviceOnly
    
    /// 항상 접근 가능 (비권장)
    case always
    
    /// 항상 접근 가능 (백업 안됨, 비권장)
    case alwaysThisDeviceOnly
    
    /// CFString 값으로 변환
    var attributeValue: CFString {
        switch self {
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .afterFirstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .whenPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        case .always:
            if #available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *) {
                return kSecAttrAccessibleAfterFirstUnlock
            } else {
                return kSecAttrAccessibleAlways
            }
        case .alwaysThisDeviceOnly:
            if #available(iOS 12.0, macOS 10.14, tvOS 12.0, watchOS 5.0, *) {
                return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
            } else {
                return kSecAttrAccessibleAlwaysThisDeviceOnly
            }
        }
    }
}


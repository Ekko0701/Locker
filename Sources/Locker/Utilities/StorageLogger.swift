//
//  StorageLogger.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// 디버깅용 스토리지 로거
public final class StorageLogger {
    /// 공유 인스턴스
    public static let shared = StorageLogger()
    
    private var isEnabled: Bool = false
    
    private init() {}
    
    /// 로깅 활성화
    public func enable() {
        isEnabled = true
    }
    
    /// 로깅 비활성화
    public func disable() {
        isEnabled = false
    }
    
    /// 로그 출력
    /// - Parameter message: 로그 메시지
    public func log(_ message: String) {
        #if DEBUG
        if isEnabled {
            let timestamp = DateFormatter.localizedString(
                from: Date(),
                dateStyle: .none,
                timeStyle: .medium
            )
            print("[\(timestamp)] [Locker] \(message)")
        }
        #endif
    }
    
    /// 모든 UserDefaults 값 출력
    public func printAllUserDefaults() {
        #if DEBUG
        guard isEnabled else { return }
        
        let dictionary = UserDefaults.standard.dictionaryRepresentation()
        print("=== UserDefaults Contents ===")
        for (key, value) in dictionary.sorted(by: { $0.key < $1.key }) {
            print("\(key): \(value)")
        }
        print("=============================")
        #endif
    }
    
    /// 특정 Suite의 모든 UserDefaults 값 출력
    /// - Parameter suiteName: Suite 이름
    public func printUserDefaults(suiteName: String) {
        #if DEBUG
        guard isEnabled else { return }
        guard let userDefaults = UserDefaults(suiteName: suiteName) else {
            print("UserDefaults Suite를 찾을 수 없습니다: \(suiteName)")
            return
        }
        
        let dictionary = userDefaults.dictionaryRepresentation()
        print("=== UserDefaults [\(suiteName)] Contents ===")
        for (key, value) in dictionary.sorted(by: { $0.key < $1.key }) {
            print("\(key): \(value)")
        }
        print("===========================================")
        #endif
    }
}


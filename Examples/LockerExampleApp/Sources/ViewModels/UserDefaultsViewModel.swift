//
//  UserDefaultsViewModel.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Combine
import Locker

class UserDefaultsViewModel: ObservableObject {
    private let storage = StorageManager.shared
    
    @Published var isDarkMode: Bool {
        didSet {
            try? storage.save(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    @Published var fontSize: Double {
        didSet {
            try? storage.save(fontSize, forKey: "fontSize")
        }
    }
    
    @Published var notificationsEnabled: Bool {
        didSet {
            try? storage.save(notificationsEnabled, forKey: "notificationsEnabled")
        }
    }
    
    @Published var language: String {
        didSet {
            try? storage.save(language, forKey: "language")
        }
    }
    
    init() {
        // 저장된 값 로드 또는 기본값 사용
        self.isDarkMode = (try? storage.load(forKey: "isDarkMode")) ?? false
        self.fontSize = (try? storage.load(forKey: "fontSize")) ?? 16.0
        self.notificationsEnabled = (try? storage.load(forKey: "notificationsEnabled")) ?? true
        self.language = (try? storage.load(forKey: "language")) ?? "ko"
    }
    
    func resetAll() {
        // 모든 설정 초기화
        isDarkMode = false
        fontSize = 16.0
        notificationsEnabled = true
        language = "ko"
    }
}


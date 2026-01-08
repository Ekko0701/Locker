//
//  UserDefaultsKey.swift
//  Locker
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation

/// UserDefaults Key 관리
///
/// 사용 예시:
/// ```swift
/// try StorageManager.shared.save(true, forKey: UserDefaultsKey.isDarkMode.rawValue)
/// ```
public enum UserDefaultsKey: String, CaseIterable {
    // 사용자 설정
    case isDarkMode = "app.settings.isDarkMode"
    case language = "app.settings.language"
    case fontSize = "app.settings.fontSize"
    case notificationEnabled = "app.settings.notificationEnabled"
    
    // 앱 상태
    case isFirstLaunch = "app.state.isFirstLaunch"
    case lastLoginDate = "app.state.lastLoginDate"
    case appVersion = "app.state.appVersion"
    case buildNumber = "app.state.buildNumber"
    
    // 기능 플래그
    case enableNotifications = "app.features.enableNotifications"
    case enableAnalytics = "app.features.enableAnalytics"
    case enableBetaFeatures = "app.features.enableBetaFeatures"
}


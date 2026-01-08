import Foundation
import Combine
import Locker

class PropertyWrapperViewModel: ObservableObject {
    // MARK: - Keychain Property Wrappers (민감 정보)
    
    @Keychain(key: "demo.accessToken", accessibility: .afterFirstUnlock)
    var accessToken: String? {
        didSet { objectWillChange.send() }
    }
    
    @Keychain(key: "demo.password", accessibility: .whenUnlockedThisDeviceOnly)
    var password: String? {
        didSet { objectWillChange.send() }
    }
    
    // MARK: - UserDefaults Property Wrappers (일반 설정)
    
    @UserDefault(key: "demo.isDarkMode", defaultValue: false)
    var isDarkMode: Bool {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.fontSize", defaultValue: 16.0)
    var fontSize: Double {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.theme", defaultValue: "auto")
    var theme: String {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.notificationsEnabled", defaultValue: true)
    var notificationsEnabled: Bool {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.username", defaultValue: "")
    var username: String {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.email", defaultValue: "")
    var email: String {
        didSet { objectWillChange.send() }
    }
    
    @UserDefault(key: "demo.loginCount", defaultValue: 0)
    var loginCount: Int {
        didSet { objectWillChange.send() }
    }
    
    // MARK: - Actions
    
    func generateNewToken() {
        accessToken = "token_\(UUID().uuidString.prefix(8))"
    }
    
    func clearToken() {
        accessToken = nil
    }
    
    func resetAllSettings() {
        // Keychain 데이터 삭제
        accessToken = nil
        password = nil
        
        // UserDefaults를 기본값으로 리셋
        isDarkMode = false
        fontSize = 16.0
        theme = "auto"
        notificationsEnabled = true
        username = ""
        email = ""
        loginCount = 0
    }
}


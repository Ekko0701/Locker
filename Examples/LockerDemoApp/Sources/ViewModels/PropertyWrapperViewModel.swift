import Foundation
import Combine
import Locker

class PropertyWrapperViewModel: ObservableObject {
    // MARK: - Storage Manager
    
    private let storage = StorageManager.shared
    
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
    
    // MARK: - 프로퍼티 래퍼 방식 (개별 삭제)
    
    func resetUsingPropertyWrappers() {
        // 프로퍼티 래퍼를 사용한 개별 삭제
        // 각 프로퍼티를 하나씩 nil 또는 기본값으로 설정
        
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
    
    // MARK: - StorageManager 방식 (배치 삭제) ⭐
    
    func resetUsingStorageManager() {
        do {
            // 방법 1: 선택적 배치 삭제 (권장)
            // Keychain에서 특정 키들만 삭제
            try storage.deleteSecureBatch(keys: [
                "demo.accessToken",
                "demo.password"
            ])
            
            // UserDefaults에서 특정 키들만 삭제
            try storage.deleteBatch(keys: [
                "demo.isDarkMode",
                "demo.fontSize",
                "demo.theme",
                "demo.notificationsEnabled",
                "demo.username",
                "demo.email",
                "demo.loginCount"
            ])
            
            // 프로퍼티 래퍼의 캐시된 값도 초기화
            objectWillChange.send()
            
            print("✅ StorageManager 배치 삭제 완료")
        } catch {
            print("❌ 삭제 실패: \(error)")
        }
    }
    
    func resetEverythingUsingStorageManager() {
        do {
            // 방법 2: 전체 삭제 (주의!)
            // 모든 Keychain 데이터 삭제
            try storage.deleteAllSecure()
            
            // 모든 UserDefaults 데이터 삭제
            try storage.deleteAll()
            
            // 프로퍼티 래퍼의 캐시된 값도 초기화
            objectWillChange.send()
            
            print("✅ 전체 삭제 완료")
        } catch {
            print("❌ 전체 삭제 실패: \(error)")
        }
    }
}


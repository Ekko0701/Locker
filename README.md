# 🔐 Locker

**Locker**는 iOS 앱에서 로컬 스토리지(Keychain, UserDefaults)를 타입 안전하게 관리하는 Swift 패키지입니다.

[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platform-iOS%2015%2B%20%7C%20macOS%2012%2B-lightgrey.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![SPM](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager)

---

## ✨ 주요 기능

- ✅ **타입 안전성**: Generic + Codable 기반 타입 안전한 저장/조회
- ✅ **확장성**: Protocol 기반으로 새로운 스토리지 타입 추가 용이
- ✅ **보안**: Keychain을 통한 민감 정보 안전 저장
- ✅ **사용 편의성**: PropertyWrapper, Facade 패턴으로 간편한 API
- ✅ **멀티 프로젝트 지원**: 네임스페이스로 프로젝트 간 격리
- ✅ **테스트 가능성**: Protocol 기반으로 Mock 가능

---

## 📦 설치

### Swift Package Manager

`Package.swift` 파일에 다음을 추가하세요:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/Locker.git", from: "1.0.0")
]
```

또는 Xcode에서:

1. `File` → `Add Package Dependencies...`
2. 저장소 URL 입력
3. 버전 선택 및 추가

---

## 🚀 빠른 시작

### 기본 사용법

```swift
import Locker

// MARK: - Keychain (민감 정보)

// 토큰 저장
let accessToken = "eyJhbGciOiJIUzI1NiIs..."
try StorageManager.shared.saveSecure(accessToken, forKey: "accessToken")

// 토큰 조회
if let token: String = try StorageManager.shared.loadSecure(forKey: "accessToken") {
    print("Token: \(token)")
}

// 토큰 삭제
try StorageManager.shared.deleteSecure(forKey: "accessToken")


// MARK: - UserDefaults (일반 설정)

// 설정 저장
try StorageManager.shared.save(true, forKey: "isDarkMode")

// 설정 조회
if let isDarkMode: Bool = try StorageManager.shared.load(forKey: "isDarkMode") {
    print("Dark Mode: \(isDarkMode)")
}
```

### 복잡한 객체 저장

```swift
struct UserProfile: Codable {
    let id: Int
    let name: String
    let email: String
}

let profile = UserProfile(id: 1, name: "김동주", email: "user@example.com")

// 저장
try StorageManager.shared.save(profile, forKey: "userProfile")

// 조회
if let loadedProfile: UserProfile = try StorageManager.shared.load(forKey: "userProfile") {
    print(loadedProfile.name)
}
```

### PropertyWrapper 사용

```swift
import Locker

class AppSettings {
    @UserDefault(key: "isDarkMode", defaultValue: false)
    var isDarkMode: Bool
    
    @UserDefault(key: "fontSize", defaultValue: 14.0)
    var fontSize: Double
    
    @UserDefault(key: "language", defaultValue: "ko")
    var language: String
}

// 사용
let settings = AppSettings()
settings.isDarkMode = true  // 자동으로 저장
print(settings.isDarkMode)  // 자동으로 로드
```

---

## 📖 상세 가이드

### Keychain 접근성 옵션

```swift
// 디바이스 잠금 해제 후 접근 가능 (기본값)
try StorageManager.shared.saveSecure(
    token,
    forKey: "token",
    accessibility: .afterFirstUnlock
)

// 디바이스 잠금 해제 시에만 접근 (백업 안됨)
try StorageManager.shared.saveSecure(
    password,
    forKey: "password",
    accessibility: .whenUnlockedThisDeviceOnly
)

// 패스코드 설정 시에만 접근 (생체 인증)
try StorageManager.shared.saveSecure(
    biometricToken,
    forKey: "biometricToken",
    accessibility: .whenPasscodeSetThisDeviceOnly
)
```

### App Groups 지원

앱 확장(Extension)과 데이터 공유:

```swift
let config = StorageConfiguration(
    keychainService: "com.yourapp.shared",
    keychainAccessGroup: "group.com.yourapp.shared",
    userDefaultsSuite: "group.com.yourapp.shared"
)

let sharedManager = StorageManager(configuration: config)

// 공유 데이터 저장
try sharedManager.save(100, forKey: "unreadCount")
```

### 배치 작업

```swift
let storage = UserDefaultsStorage()

// 여러 값 한번에 저장
try storage.saveBatch([
    "key1": "value1",
    "key2": "value2",
    "key3": "value3"
])

// 여러 값 한번에 조회
let values: [String: String?] = try storage.loadBatch(keys: ["key1", "key2", "key3"])

// 여러 키 한번에 삭제
try storage.deleteBatch(keys: ["key1", "key2", "key3"])
```

### 마이그레이션

```swift
// UserDefaults 키 마이그레이션
try StorageMigration.migrate(from: "oldKey", to: "newKey")

// UserDefaults → Keychain 마이그레이션
try StorageMigration.migrateToKeychain(key: "sensitiveData")

// 배치 마이그레이션
try StorageMigration.batchMigrate(migrations: [
    (oldKey: "old.key1", newKey: "new.key1"),
    (oldKey: "old.key2", newKey: "new.key2")
])
```

### 디버깅

```swift
// 디버그 로깅 활성화
let config = StorageConfiguration(enableDebugLogging: true)
let manager = StorageManager(configuration: config)

// 또는
StorageLogger.shared.enable()

// 모든 UserDefaults 출력
StorageLogger.shared.printAllUserDefaults()
```

---

## 🔒 보안 고려사항

### 민감 정보 분류

| 정보 유형 | 저장 위치 | 접근성 |
|----------|----------|--------|
| 액세스 토큰, 리프레시 토큰 | Keychain | `afterFirstUnlock` |
| 비밀번호, PIN | Keychain | `whenUnlockedThisDeviceOnly` |
| 사용자 ID, 이메일 | UserDefaults | - |
| 앱 설정, 테마 | UserDefaults | - |
| 생체 인증 토큰 | Keychain | `whenPasscodeSetThisDeviceOnly` |

### 권장사항

1. **Keychain 사용 원칙**
   - 토큰, 비밀번호는 반드시 Keychain 사용
   - `accessGroup` 설정으로 앱 확장 간 안전한 공유
   - 적절한 `accessibility` 설정

2. **UserDefaults 주의사항**
   - 민감 정보 저장 금지
   - 앱 설정, 사용자 기본 설정만 저장

3. **데이터 라이프사이클**
   - 로그아웃 시 민감 정보 완전 삭제
   - 토큰 만료 시간 관리

---

## 🏗️ 아키텍처

### 계층 구조

```
┌─────────────────────────────────────┐
│      Application Layer              │
│  (Your App)                         │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      StorageManager (Facade)        │
│  - 통합 인터페이스                   │
│  - 사용 편의성 제공                  │
└──────────────┬──────────────────────┘
               │
    ┌──────────┴──────────┐
    │                     │
┌───▼────────┐   ┌────────▼────┐
│ Keychain   │   │ UserDefaults│
│ Storage    │   │  Storage    │
└────────────┘   └─────────────┘
    │                     │
    └──────────┬──────────┘
               │
    ┌──────────▼──────────┐
    │  StorageProtocol    │
    │  (Core Interface)   │
    └─────────────────────┘
```

### 설계 패턴

- **Protocol-Oriented Programming**: 확장 가능한 인터페이스 설계
- **Facade Pattern**: `StorageManager`로 복잡도 숨김
- **Dependency Injection**: 테스트 가능한 구조
- **Strategy Pattern**: 스토리지 타입별 구현 분리

---

## 🧪 테스트

```swift
import XCTest
@testable import Locker

final class MyTests: XCTestCase {
    var storage: KeychainStorage!
    
    override func setUp() {
        super.setUp()
        storage = KeychainStorage(service: "com.test")
    }
    
    override func tearDown() {
        try? storage.deleteAll()
        super.tearDown()
    }
    
    func testSaveAndLoad() throws {
        // Given
        let token = "TestToken"
        
        // When
        try storage.save(token, forKey: "token")
        let loaded: String? = try storage.load(forKey: "token")
        
        // Then
        XCTAssertEqual(token, loaded)
    }
}
```

테스트 실행:

```bash
swift test
```

---

## 📚 API 문서

### StorageManager

메인 Facade 클래스. 모든 스토리지 작업의 진입점.

#### Keychain 메서드

- `saveSecure<T: Codable>(_ value: T, forKey key: String, accessibility: KeychainAccessibility) throws`
- `loadSecure<T: Codable>(forKey key: String) throws -> T?`
- `deleteSecure(forKey key: String) throws`
- `existsInSecure(forKey key: String) -> Bool`
- `deleteAllSecure() throws`

#### UserDefaults 메서드

- `save<T: Codable>(_ value: T, forKey key: String) throws`
- `load<T: Codable>(forKey key: String) throws -> T?`
- `delete(forKey key: String) throws`
- `exists(forKey key: String) -> Bool`
- `deleteAll() throws`

### StorageProtocol

모든 스토리지가 준수해야 하는 프로토콜.

```swift
protocol StorageProtocol {
    func save<T: Codable>(_ value: T, forKey key: String) throws
    func load<T: Codable>(forKey key: String) throws -> T?
    func delete(forKey key: String) throws
    func deleteAll() throws
    func exists(forKey key: String) -> Bool
}
```

---

## 🛠️ 요구사항

- iOS 15.0+
- macOS 12.0+
- tvOS 15.0+
- watchOS 8.0+
- Swift 5.9+
- Xcode 15.0+

---

## 📝 라이선스

MIT License. 자세한 내용은 [LICENSE](LICENSE) 파일을 참고하세요.

---

## 👥 기여

기여는 언제나 환영합니다! 

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📮 문의

프로젝트 관련 문의사항이나 제안사항이 있으시면 Issue를 생성해주세요.

---

## 🙏 감사

이 프로젝트는 [StorageKit 설계 문서](Documents/StorageKit-Design.md)를 기반으로 구현되었습니다.

---

**Locker** - 안전하고 효율적인 로컬 스토리지 관리 솔루션 🚀


# 🔐 Locker Example App

Locker 라이브러리의 기능을 시연하는 완전히 독립적인 iOS 예제 앱입니다.

> ⚠️ **중요**: 이 앱은 Locker 라이브러리와 완전히 분리되어 있으며, 루트의 Locker 소스를 수정하지 않습니다.

## 📋 요구사항

- iOS 15.0+
- Xcode 15.0+
- Tuist 4.0+
- Swift 5.9+

## 🚀 빌드 및 실행

### 방법 1: Tuist 사용 (권장)

#### 1. Tuist 설치

```bash
curl -Ls https://install.tuist.io | bash
```

또는 Homebrew 사용:

```bash
brew install tuist
```

#### 2. 프로젝트 생성 및 열기

```bash
cd Examples/LockerExampleApp
tuist generate --open
```

또는 단계별로:

```bash
cd Examples/LockerExampleApp
tuist generate
open LockerExampleApp.xcworkspace
```

> **주의**: `.xcworkspace` 파일을 열어야 Locker 패키지가 올바르게 로드됩니다.

### 방법 2: Xcode에서 직접 열기

이미 `tuist generate`를 실행했다면:

```bash
open Examples/LockerExampleApp/LockerExampleApp.xcworkspace
```

## 📱 앱 기능

### 1. UserDefaults 데모 탭
- 앱 설정 저장/조회 시연
- 다크 모드 토글
- 폰트 크기 조절
- 알림 설정
- 언어 선택
- 실시간 데이터 표시

### 2. Keychain 데모 탭
- 보안 토큰 저장/조회 시연
- 액세스 토큰 관리
- 리프레시 토큰 관리
- 다양한 접근성 옵션 설명
- 저장된 토큰 표시

### 3. 인증 데모 탭
- 로그인/로그아웃 시뮬레이션
- Keychain에 토큰 저장
- UserDefaults에 사용자 정보 저장
- 로그인 상태 유지
- 저장된 인증 정보 표시

## 🏗️ 프로젝트 구조

```
LockerExampleApp/
├── Project.swift                    # Tuist 프로젝트 매니페스트
├── Sources/
│   ├── LockerExampleApp.swift      # 앱 진입점
│   ├── ContentView.swift            # 메인 탭 뷰
│   ├── Views/
│   │   ├── UserDefaultsView.swift  # UserDefaults 데모
│   │   ├── KeychainDemoView.swift  # Keychain 데모
│   │   └── AuthenticationView.swift # 인증 데모
│   └── ViewModels/
│       ├── UserDefaultsViewModel.swift
│       ├── KeychainViewModel.swift
│       └── AuthenticationViewModel.swift
├── Resources/
│   └── LaunchScreen.storyboard
└── README.md
```

## 💡 주요 학습 포인트

### 1. StorageManager 사용법
```swift
import Locker

// UserDefaults 저장
try StorageManager.shared.save(value, forKey: "key")

// Keychain 저장
try StorageManager.shared.saveSecure(value, forKey: "key")
```

### 2. ViewModel 패턴
```swift
class MyViewModel: ObservableObject {
    private let storage = StorageManager.shared
    
    @Published var data: String = ""
    
    func save() {
        try? storage.save(data, forKey: "data")
    }
}
```

### 3. 에러 핸들링
```swift
do {
    try storage.saveSecure(token, forKey: "token")
} catch StorageError.keychainError(let status) {
    print("Keychain 에러: \(status)")
} catch {
    print("에러: \(error)")
}
```

## 🔒 보안 고려사항

이 예제 앱은 다음 보안 원칙을 따릅니다:

1. **민감한 정보는 Keychain에 저장**
   - 액세스 토큰
   - 리프레시 토큰

2. **일반 설정은 UserDefaults에 저장**
   - 사용자 이메일
   - 앱 설정
   - 로그인 상태

3. **적절한 Keychain 접근성 옵션 사용**
   - `afterFirstUnlock`: 일반 토큰
   - `whenUnlockedThisDeviceOnly`: 민감한 정보
   - `whenPasscodeSetThisDeviceOnly`: 생체 인증 정보

## 📚 참고 자료

- [Locker 라이브러리 문서](../../README.md)
- [Locker API 레퍼런스](../../Documents/API-REFERENCE.md)
- [Tuist 공식 문서](https://docs.tuist.io)

## 🐛 문제 해결

### 프로젝트 생성 실패
```bash
cd Examples/LockerExampleApp
tuist clean
tuist generate
```

### Locker 패키지를 찾을 수 없음
반드시 `.xcworkspace` 파일을 열어야 합니다:
```bash
open LockerExampleApp.xcworkspace
```

### 의존성 문제
```bash
# 프로젝트 정리 후 재생성
tuist clean
rm -rf Derived
rm -rf LockerExampleApp.xcodeproj
rm -rf LockerExampleApp.xcworkspace
tuist generate
```

### Xcode 캐시 문제
```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
cd Examples/LockerExampleApp
tuist clean
tuist generate
```

### 빌드 오류
1. Xcode를 완전히 종료
2. 다음 명령 실행:
```bash
cd Examples/LockerExampleApp
tuist clean
rm -rf ~/Library/Developer/Xcode/DerivedData
tuist generate --open
```

## 📝 라이선스

이 예제 앱은 Locker 라이브러리와 동일한 MIT 라이선스를 따릅니다.


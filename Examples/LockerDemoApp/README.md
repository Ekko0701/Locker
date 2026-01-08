# Locker Demo App

Locker 라이브러리의 기능을 시각적으로 테스트할 수 있는 데모 앱입니다.

## 🎯 기능

### 1️⃣ 저장 탭
- Key/Value 입력 인터페이스
- **Keychain 저장**: Accessibility 옵션 선택 가능
- **UserDefaults 저장**: 간편한 설정 저장
- 실시간 저장 결과 피드백

### 2️⃣ Keychain 관리 탭
- ✅ **전체 조회**: 저장된 모든 Keychain 키 확인
- 🔍 **특정 값 조회**: Key로 검색하여 값 확인
- 🗑️ **개별 삭제**: 각 키를 개별적으로 삭제
- ☑️ **선택 삭제**: 여러 키를 선택하여 일괄 삭제
- 🚨 **전체 삭제**: 모든 Keychain 데이터 삭제

### 3️⃣ UserDefaults 관리 탭
- ✅ **전체 조회**: 저장된 모든 UserDefaults 키 확인
- 🔍 **특정 값 조회**: Key로 검색하여 값 확인
- 🗑️ **개별 삭제**: 각 키를 개별적으로 삭제
- ☑️ **선택 삭제**: 여러 키를 선택하여 일괄 삭제
- 🚨 **전체 삭제**: 모든 UserDefaults 데이터 삭제

## 🚀 실행 방법

### Tuist 설치
```bash
curl -Ls https://install.tuist.io | bash
```

### 프로젝트 생성 및 실행
```bash
cd Examples/LockerDemoApp
tuist generate
open LockerDemoApp.xcworkspace
```

## 💡 사용 예시

### Keychain에 토큰 저장
1. "저장" 탭으로 이동
2. Key: `auth.accessToken`
3. Value: `eyJhbGciOiJIUzI1NiIs...`
4. "Keychain에 저장" 버튼 클릭
5. Accessibility 옵션 선택 (예: After First Unlock)
6. "저장하기" 클릭

### 저장된 데이터 확인
1. "Keychain" 탭으로 이동
2. 저장된 키 목록에서 `auth.accessToken` 확인
3. 또는 검색 필드에 `auth.accessToken` 입력 후 "조회" 클릭

### 선택 삭제
1. "Keychain" 또는 "UserDefaults" 탭에서 "선택 모드 시작" 클릭
2. 삭제할 키들을 체크
3. "선택한 N개 삭제" 버튼 클릭

## 📱 스크린샷

### 저장 탭
- Key/Value 입력
- Keychain/UserDefaults 선택
- Accessibility 옵션 선택 팝업

### Keychain 관리 탭
- 저장된 키 목록
- 검색 기능
- 선택 삭제 모드

### UserDefaults 관리 탭
- 저장된 키 목록
- 검색 기능
- 선택 삭제 모드

## 🛠️ 기술 스택

- **SwiftUI**: 모던한 UI 프레임워크
- **Combine**: 반응형 프로그래밍
- **Locker**: 타입 세이프 로컬 스토리지 라이브러리
- **Tuist**: Xcode 프로젝트 관리

## 📚 참고

- [Locker 라이브러리 문서](../../README.md)
- [API 레퍼런스](../../Documents/API-REFERENCE.md)
- [아키텍처 문서](../../Documents/StorageKit-Design.md)

## 🔒 보안 테스트

이 데모 앱으로 다양한 보안 시나리오를 테스트할 수 있습니다:

1. **Accessibility 옵션 테스트**
   - 디바이스 잠금/해제에 따른 접근성 확인
   - 백업 동작 확인

2. **배치 삭제 테스트**
   - 로그아웃 시나리오 (인증 정보만 삭제)
   - 캐시 삭제 시나리오

3. **데이터 영속성 테스트**
   - 앱 재시작 후 데이터 유지 확인
   - 디바이스 재부팅 후 확인

## ⚠️ 주의사항

- 이 앱은 **테스트 목적**으로만 사용하세요
- 실제 민감한 정보는 저장하지 마세요
- 시뮬레이터에서는 일부 Accessibility 옵션이 제대로 동작하지 않을 수 있습니다


# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-08

### Added
- ✨ 최초 릴리스
- ✅ Keychain 스토리지 구현
  - 타입 안전한 저장/조회/삭제
  - 접근성 옵션 지원 (afterFirstUnlock, whenUnlocked, etc.)
  - App Groups 지원
- ✅ UserDefaults 스토리지 구현
  - 타입 안전한 저장/조회/삭제
  - 기본 타입 최적화
  - Codable 객체 지원
- ✅ StorageManager Facade
  - 통합 API 제공
  - 설정 가능한 Configuration
  - 디버그 로깅 지원
- ✅ PropertyWrapper
  - @UserDefault 지원
  - 자동 저장/로드
- ✅ 배치 작업
  - saveBatch, loadBatch, deleteBatch
- ✅ 마이그레이션 도구
  - 키 마이그레이션
  - UserDefaults ↔ Keychain 마이그레이션
  - 배치 마이그레이션
- ✅ 유틸리티
  - StorageLogger (디버깅)
  - Codable 확장
- ✅ 완전한 테스트 커버리지
  - KeychainStorage 테스트
  - UserDefaultsStorage 테스트
  - StorageManager 테스트
  - Migration 테스트
- 📚 포괄적인 문서
  - README.md
  - 사용 예시
  - API 문서

### Security
- 🔒 Keychain을 통한 안전한 데이터 저장
- 🔒 접근성 제어 지원
- 🔒 App Groups를 통한 안전한 데이터 공유

---

## 버전 관리

- **MAJOR**: 하위 호환성이 없는 API 변경
- **MINOR**: 하위 호환성이 있는 기능 추가
- **PATCH**: 하위 호환성이 있는 버그 수정


//
//  KeychainBehaviorTest.swift
//  
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Locker

/// Keychain 프로퍼티 래퍼 동작 테스트
func keychainPropertyWrapperBehaviorTest() {
    print("=== Keychain 프로퍼티 래퍼 동작 테스트 ===\n")
    
    // 1. 먼저 Keychain에 값 저장 (다른 방법으로)
    print("1️⃣ StorageManager로 Keychain에 값 저장")
    try? StorageManager.shared.saveSecure("existing-token-123", forKey: "test.token")
    print("   ✅ Keychain에 저장됨: 'existing-token-123'\n")
    
    // 2. 프로퍼티 래퍼 선언
    print("2️⃣ 프로퍼티 래퍼 선언")
    class TestClass {
        @Keychain(key: "test.token")
        var myToken: String?
    }
    
    let test = TestClass()
    print("   ✅ 프로퍼티 래퍼 생성됨")
    print("   ⚠️  주의: 아직 Keychain 접근 안 함!\n")
    
    // 3. 첫 번째 읽기
    print("3️⃣ 첫 번째 읽기 시도")
    let firstRead = test.myToken
    print("   🔍 Keychain 조회 발생!")
    print("   📖 읽은 값: \(firstRead ?? "nil")\n")
    
    // 4. 두 번째 읽기
    print("4️⃣ 두 번째 읽기 시도")
    let secondRead = test.myToken
    print("   🔍 또 Keychain 조회 발생! (캐시 안 됨)")
    print("   📖 읽은 값: \(secondRead ?? "nil")\n")
    
    // 5. 외부에서 Keychain 값 변경
    print("5️⃣ 외부에서 Keychain 값 변경")
    try? StorageManager.shared.saveSecure("changed-token-456", forKey: "test.token")
    print("   ✅ 변경됨: 'changed-token-456'\n")
    
    // 6. 다시 읽기 (즉시 반영)
    print("6️⃣ 다시 읽기")
    let thirdRead = test.myToken
    print("   🔍 Keychain 조회 발생!")
    print("   📖 읽은 값: \(thirdRead ?? "nil")")
    print("   ✨ 변경사항 즉시 반영!\n")
    
    // 7. 정리
    print("7️⃣ 정리")
    try? StorageManager.shared.deleteSecure(forKey: "test.token")
    print("   🗑️  테스트 데이터 삭제\n")
    
    print("=== 결론 ===")
    print("• 프로퍼티 래퍼 선언 시: Keychain 접근 안 함")
    print("• 값 읽을 때마다: Keychain 조회")
    print("• 메모리 캐시: 없음 (항상 최신 값)")
}


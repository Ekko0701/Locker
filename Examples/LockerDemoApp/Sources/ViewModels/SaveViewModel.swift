import Foundation
import Combine
import Locker

class SaveViewModel: ObservableObject {
    @Published var resultMessage: String?
    @Published var isSuccess: Bool = false
    
    private let storage = StorageManager.shared
    
    func saveToKeychain(key: String, value: String, accessibility: KeychainAccessibility) {
        guard !key.isEmpty && !value.isEmpty else {
            showError("Key와 Value를 모두 입력해주세요")
            return
        }
        
        do {
            try storage.saveSecure(value, forKey: key, accessibility: accessibility)
            showSuccess("✅ Keychain에 저장 완료: \(key)")
        } catch {
            showError("❌ Keychain 저장 실패: \(error.localizedDescription)")
        }
    }
    
    func saveToUserDefaults(key: String, value: String) {
        guard !key.isEmpty && !value.isEmpty else {
            showError("Key와 Value를 모두 입력해주세요")
            return
        }
        
        do {
            try storage.save(value, forKey: key)
            showSuccess("✅ UserDefaults에 저장 완료: \(key)")
        } catch {
            showError("❌ UserDefaults 저장 실패: \(error.localizedDescription)")
        }
    }
    
    private func showSuccess(_ message: String) {
        isSuccess = true
        resultMessage = message
        
        // 3초 후 메시지 자동 삭제
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resultMessage = nil
        }
    }
    
    private func showError(_ message: String) {
        isSuccess = false
        resultMessage = message
        
        // 3초 후 메시지 자동 삭제
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.resultMessage = nil
        }
    }
}


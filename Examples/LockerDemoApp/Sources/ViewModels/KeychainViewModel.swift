import Foundation
import Combine
import Locker
import Security

class KeychainViewModel: ObservableObject {
    @Published var keychainKeys: [String] = []
    @Published var searchResult: String?
    @Published var statusMessage: String?
    @Published var isSuccess: Bool = false
    @Published var isSelectionMode: Bool = false
    @Published var selectedKeys: Set<String> = []
    
    private let storage = StorageManager.shared
    private var keychainValues: [String: String] = [:]
    
    func refreshKeys() {
        // Keychain에서 모든 키 가져오기
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        if status == errSecSuccess, let items = result as? [[String: Any]] {
            var keys: [String] = []
            var values: [String: String] = [:]
            
            for item in items {
                // kSecAttrAccount는 String 또는 Data로 나올 수 있음
                let key: String?
                if let keyString = item[kSecAttrAccount as String] as? String {
                    key = keyString
                } else if let keyData = item[kSecAttrAccount as String] as? Data {
                    key = String(data: keyData, encoding: .utf8)
                } else {
                    key = nil
                }
                
                if let key = key {
                    keys.append(key)
                    
                    // 값도 가져오기
                    if let value: String = try? storage.loadSecure(forKey: key) {
                        values[key] = value
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.keychainKeys = keys.sorted()
                self.keychainValues = values
            }
        } else {
            DispatchQueue.main.async {
                self.keychainKeys = []
                self.keychainValues = [:]
            }
        }
    }
    
    func searchKey(_ key: String) {
        do {
            if let value: String = try storage.loadSecure(forKey: key) {
                searchResult = value
                showSuccess("✅ 조회 성공")
            } else {
                searchResult = "값이 없습니다"
                showError("❌ 해당 키를 찾을 수 없습니다")
            }
        } catch {
            searchResult = "조회 실패"
            showError("❌ 조회 실패: \(error.localizedDescription)")
        }
    }
    
    func getValue(for key: String) -> String? {
        return keychainValues[key]
    }
    
    func deleteKey(_ key: String) {
        do {
            try storage.deleteSecure(forKey: key)
            showSuccess("✅ 삭제 완료: \(key)")
            refreshKeys()
        } catch {
            showError("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        do {
            try storage.deleteAllSecure()
            showSuccess("✅ 전체 삭제 완료")
            keychainKeys = []
            keychainValues = [:]
            selectedKeys = []
            isSelectionMode = false
        } catch {
            showError("❌ 전체 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func toggleSelectionMode() {
        isSelectionMode.toggle()
        if !isSelectionMode {
            selectedKeys.removeAll()
        }
    }
    
    func toggleSelection(_ key: String) {
        if selectedKeys.contains(key) {
            selectedKeys.remove(key)
        } else {
            selectedKeys.insert(key)
        }
    }
    
    func deleteSelectedKeys() {
        do {
            try storage.deleteSecureBatch(keys: Array(selectedKeys))
            showSuccess("✅ \(selectedKeys.count)개 키 삭제 완료")
            selectedKeys.removeAll()
            isSelectionMode = false
            refreshKeys()
        } catch {
            showError("❌ 선택 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    private func showSuccess(_ message: String) {
        isSuccess = true
        statusMessage = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusMessage = nil
        }
    }
    
    private func showError(_ message: String) {
        isSuccess = false
        statusMessage = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.statusMessage = nil
        }
    }
}


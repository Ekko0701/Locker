import Foundation
import Combine
import Locker

class UserDefaultsViewModel: ObservableObject {
    @Published var userDefaultsKeys: [String] = []
    @Published var searchResult: String?
    @Published var statusMessage: String?
    @Published var isSuccess: Bool = false
    @Published var isSelectionMode: Bool = false
    @Published var selectedKeys: Set<String> = []
    
    private let storage = StorageManager.shared
    private let userDefaults = UserDefaults.standard
    private var userDefaultsValues: [String: String] = [:]
    
    func refreshKeys() {
        // StorageManager를 사용하여 모든 키 가져오기
        let keys = storage.getAllKeys()
        var values: [String: String] = [:]
        
        // 각 키의 값도 가져오기
        for key in keys {
            if let value = userDefaults.object(forKey: key) {
                // 값을 문자열로 변환
                if let stringValue = value as? String {
                    values[key] = stringValue
                } else if let data = value as? Data, let string = String(data: data, encoding: .utf8) {
                    values[key] = string
                } else {
                    values[key] = "\(value)"
                }
            }
        }
        
        DispatchQueue.main.async {
            self.userDefaultsKeys = keys
            self.userDefaultsValues = values
        }
    }
    
    func searchKey(_ key: String) {
        do {
            if let value: String = try storage.load(forKey: key) {
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
        return userDefaultsValues[key]
    }
    
    func deleteKey(_ key: String) {
        do {
            try storage.delete(forKey: key)
            showSuccess("✅ 삭제 완료: \(key)")
            refreshKeys()
        } catch {
            showError("❌ 삭제 실패: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        do {
            // 앱의 모든 UserDefaults 키만 삭제 (시스템 키 제외)
            let keysToDelete = userDefaultsKeys
            try storage.deleteBatch(keys: keysToDelete)
            
            showSuccess("✅ 전체 삭제 완료 (\(keysToDelete.count)개)")
            userDefaultsKeys = []
            userDefaultsValues = [:]
            selectedKeys = []
            isSelectionMode = false
            refreshKeys()
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
            try storage.deleteBatch(keys: Array(selectedKeys))
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


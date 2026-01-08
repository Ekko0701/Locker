import SwiftUI
import Locker

struct SaveView: View {
    @StateObject private var viewModel = SaveViewModel()
    @State private var keyInput: String = ""
    @State private var valueInput: String = ""
    @State private var showAccessibilityPicker = false
    @State private var selectedAccessibility: KeychainAccessibility = .afterFirstUnlock
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("데이터 입력")) {
                    TextField("Key", text: $keyInput)
                        .autocapitalization(.none)
                    
                    TextField("Value", text: $valueInput)
                }
                
                Section(header: Text("저장 옵션")) {
                    // Keychain 저장
                    Button(action: {
                        showAccessibilityPicker = true
                    }) {
                        HStack {
                            Image(systemName: "key.fill")
                                .foregroundColor(.blue)
                            Text("Keychain에 저장")
                            Spacer()
                            Text(accessibilityName(selectedAccessibility))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // UserDefaults 저장
                    Button(action: {
                        viewModel.saveToUserDefaults(key: keyInput, value: valueInput)
                        clearInputs()
                    }) {
                        HStack {
                            Image(systemName: "gearshape.fill")
                                .foregroundColor(.green)
                            Text("UserDefaults에 저장")
                        }
                    }
                }
                
                if let message = viewModel.resultMessage {
                    Section {
                        HStack {
                            Image(systemName: viewModel.isSuccess ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(viewModel.isSuccess ? .green : .red)
                            Text(message)
                                .font(.callout)
                        }
                    }
                }
                
                Section(header: Text("팁")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("• Key: 저장할 키 이름 (예: auth.token)")
                            .font(.caption)
                        Text("• Value: 저장할 값 (문자열)")
                            .font(.caption)
                        Text("• Keychain: 민감한 정보 (토큰, 비밀번호)")
                            .font(.caption)
                        Text("• UserDefaults: 일반 설정 (테마, 폰트)")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("데이터 저장")
            .sheet(isPresented: $showAccessibilityPicker) {
                AccessibilityPickerView(
                    selectedAccessibility: $selectedAccessibility,
                    onSave: {
                        viewModel.saveToKeychain(
                            key: keyInput,
                            value: valueInput,
                            accessibility: selectedAccessibility
                        )
                        clearInputs()
                        showAccessibilityPicker = false
                    }
                )
            }
        }
    }
    
    private func clearInputs() {
        keyInput = ""
        valueInput = ""
    }
    
    private func accessibilityName(_ accessibility: KeychainAccessibility) -> String {
        switch accessibility {
        case .afterFirstUnlock:
            return "After First Unlock"
        case .afterFirstUnlockThisDeviceOnly:
            return "After First Unlock (Device Only)"
        case .whenUnlocked:
            return "When Unlocked"
        case .whenUnlockedThisDeviceOnly:
            return "When Unlocked (Device Only)"
        case .whenPasscodeSetThisDeviceOnly:
            return "When Passcode Set"
        case .always:
            return "Always"
        case .alwaysThisDeviceOnly:
            return "Always (Device Only)"
        }
    }
}

// Accessibility Picker Sheet
struct AccessibilityPickerView: View {
    @Binding var selectedAccessibility: KeychainAccessibility
    let onSave: () -> Void
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Accessibility 옵션 선택")) {
                    accessibilityOption(.afterFirstUnlock, "After First Unlock", "디바이스 첫 잠금 해제 후 접근 가능 (기본값)")
                    accessibilityOption(.afterFirstUnlockThisDeviceOnly, "After First Unlock (Device Only)", "디바이스 첫 잠금 해제 후 접근 가능, 백업 안됨")
                    accessibilityOption(.whenUnlocked, "When Unlocked", "디바이스 잠금 해제 시에만 접근 가능")
                    accessibilityOption(.whenUnlockedThisDeviceOnly, "When Unlocked (Device Only)", "디바이스 잠금 해제 시에만 접근 가능, 백업 안됨")
                    accessibilityOption(.whenPasscodeSetThisDeviceOnly, "When Passcode Set", "패스코드 설정 시에만 접근 가능 (생체 인증)")
                }
                
                Section(header: Text("비권장 옵션")) {
                    accessibilityOption(.always, "Always", "항상 접근 가능 (보안 취약)")
                    accessibilityOption(.alwaysThisDeviceOnly, "Always (Device Only)", "항상 접근 가능, 백업 안됨 (보안 취약)")
                }
                
                Section {
                    Button(action: {
                        onSave()
                    }) {
                        HStack {
                            Spacer()
                            Text("저장하기")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Accessibility 선택")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("취소") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func accessibilityOption(_ option: KeychainAccessibility, _ title: String, _ description: String) -> some View {
        Button(action: {
            selectedAccessibility = option
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.primary)
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if selectedAccessibility == option {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

#Preview {
    SaveView()
}


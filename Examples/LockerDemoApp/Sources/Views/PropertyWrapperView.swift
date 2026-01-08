import SwiftUI
import Locker

struct PropertyWrapperView: View {
    @StateObject private var viewModel = PropertyWrapperViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("프로퍼티 래퍼 데모")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("@Keychain과 @UserDefault를 사용한 자동 저장/로드")
                            .font(.headline)
                        
                        Text("값을 변경하면 자동으로 저장되고, 앱 재시작 시 자동으로 복원됩니다.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Keychain 프로퍼티 래퍼
                Section(header: Text("@Keychain (토큰 관리)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Access Token:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.accessToken ?? "없음")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Button("새 토큰 생성") {
                            viewModel.generateNewToken()
                        }
                        
                        Button("토큰 삭제") {
                            viewModel.clearToken()
                        }
                        .foregroundColor(.red)
                        .disabled(viewModel.accessToken == nil)
                    }
                }
                
                Section(header: Text("@Keychain (사용자 정보)")) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("저장된 비밀번호:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Spacer()
                            Text(viewModel.password != nil ? "••••••" : "없음")
                                .font(.caption)
                        }
                        
                        TextField("비밀번호 입력", text: Binding(
                            get: { viewModel.password ?? "" },
                            set: { viewModel.password = $0.isEmpty ? nil : $0 }
                        ))
                        .textContentType(.password)
                        
                        Button("비밀번호 삭제") {
                            viewModel.password = nil
                        }
                        .foregroundColor(.red)
                        .disabled(viewModel.password == nil)
                    }
                }
                
                // UserDefaults 프로퍼티 래퍼
                Section(header: Text("@UserDefault (앱 설정)")) {
                    Toggle("다크 모드", isOn: $viewModel.isDarkMode)
                    
                    HStack {
                        Text("폰트 크기: \(Int(viewModel.fontSize))")
                        Spacer()
                        Slider(value: $viewModel.fontSize, in: 12...24, step: 1)
                    }
                    
                    Picker("테마", selection: $viewModel.theme) {
                        Text("라이트").tag("light")
                        Text("다크").tag("dark")
                        Text("자동").tag("auto")
                    }
                    
                    Toggle("알림 활성화", isOn: $viewModel.notificationsEnabled)
                }
                
                Section(header: Text("@UserDefault (사용자 정보)")) {
                    TextField("사용자 이름", text: $viewModel.username)
                    
                    TextField("이메일", text: $viewModel.email)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    Stepper("로그인 횟수: \(viewModel.loginCount)", value: $viewModel.loginCount)
                }
                
                // 현재 값 표시
                Section(header: Text("현재 저장된 값")) {
                    VStack(alignment: .leading, spacing: 8) {
                        infoRow("Access Token", viewModel.accessToken ?? "없음")
                        infoRow("Password", viewModel.password != nil ? "설정됨" : "없음")
                        infoRow("Dark Mode", viewModel.isDarkMode ? "활성화" : "비활성화")
                        infoRow("Font Size", "\(Int(viewModel.fontSize))")
                        infoRow("Theme", viewModel.theme)
                        infoRow("Notifications", viewModel.notificationsEnabled ? "활성화" : "비활성화")
                        infoRow("Username", viewModel.username)
                        infoRow("Email", viewModel.email)
                        infoRow("Login Count", "\(viewModel.loginCount)")
                    }
                    .font(.caption)
                }
                
                Section(header: Text("액션")) {
                    Button("모든 설정 초기화") {
                        viewModel.resetAllSettings()
                    }
                    .foregroundColor(.red)
                }
                
                Section(header: Text("💡 사용 방법")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("1. 값을 변경하면 자동으로 저장됩니다")
                        Text("2. 앱을 종료하고 다시 실행해도 값이 유지됩니다")
                        Text("3. @Keychain: 민감한 정보 (토큰, 비밀번호)")
                        Text("4. @UserDefault: 일반 설정 (테마, 폰트 등)")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .navigationTitle("프로퍼티 래퍼")
        }
    }
    
    private func infoRow(_ key: String, _ value: String) -> some View {
        HStack {
            Text(key + ":")
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    PropertyWrapperView()
}


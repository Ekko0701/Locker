//
//  KeychainDemoView.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import SwiftUI
import Locker

struct KeychainDemoView: View {
    @StateObject private var viewModel = KeychainViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("액세스 토큰")) {
                    TextField("토큰 입력", text: $viewModel.accessTokenInput)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    Button(action: viewModel.saveAccessToken) {
                        Label("토큰 저장", systemImage: "square.and.arrow.down")
                    }
                    
                    if let token = viewModel.savedAccessToken {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("저장된 토큰:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(token)
                                .font(.system(.body, design: .monospaced))
                                .lineLimit(2)
                        }
                    }
                }
                
                Section(header: Text("리프레시 토큰")) {
                    TextField("리프레시 토큰 입력", text: $viewModel.refreshTokenInput)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    Button(action: viewModel.saveRefreshToken) {
                        Label("토큰 저장", systemImage: "square.and.arrow.down")
                    }
                    
                    if let token = viewModel.savedRefreshToken {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("저장된 리프레시 토큰:")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(token)
                                .font(.system(.body, design: .monospaced))
                                .lineLimit(2)
                        }
                    }
                }
                
                Section(header: Text("접근성 옵션 테스트")) {
                    VStack(alignment: .leading, spacing: 12) {
                        AccessibilityOption(
                            title: "afterFirstUnlock",
                            description: "디바이스 잠금 해제 후 접근 가능"
                        )
                        
                        AccessibilityOption(
                            title: "whenUnlockedThisDeviceOnly",
                            description: "디바이스 잠금 해제 시에만 (백업 안됨)"
                        )
                        
                        AccessibilityOption(
                            title: "whenPasscodeSetThisDeviceOnly",
                            description: "패스코드 설정 시에만"
                        )
                    }
                    .font(.caption)
                }
                
                Section(header: Text("작업")) {
                    Button(action: viewModel.loadTokens) {
                        Label("모든 토큰 다시 로드", systemImage: "arrow.clockwise")
                    }
                    
                    Button(role: .destructive, action: viewModel.deleteAllTokens) {
                        Label("모든 토큰 삭제", systemImage: "trash")
                    }
                }
                
                if let error = viewModel.errorMessage {
                    Section(header: Text("오류")) {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Keychain 데모")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct AccessibilityOption: View {
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .fontWeight(.medium)
            Text(description)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    KeychainDemoView()
}


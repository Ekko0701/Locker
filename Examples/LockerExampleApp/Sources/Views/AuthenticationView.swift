//
//  AuthenticationView.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import SwiftUI
import Locker

struct AuthenticationView: View {
    @StateObject private var viewModel = AuthenticationViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if viewModel.isLoggedIn {
                    // 로그인 상태
                    loggedInView
                } else {
                    // 로그아웃 상태
                    loginFormView
                }
            }
            .padding()
            .navigationTitle("인증 데모")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private var loginFormView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("로그인")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                TextField("이메일", text: $viewModel.email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
                SecureField("비밀번호", text: $viewModel.password)
                    .textFieldStyle(.roundedBorder)
            }
            
            Button(action: viewModel.login) {
                Text("로그인")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!viewModel.isLoginButtonEnabled)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Spacer()
        }
    }
    
    private var loggedInView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("로그인 성공")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 12) {
                InfoRow(title: "이메일", value: viewModel.userEmail ?? "N/A")
                InfoRow(title: "로그인 시간", value: viewModel.lastLoginDate ?? "N/A")
                
                Divider()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("저장된 토큰 (Keychain)")
                        .font(.headline)
                    
                    if let accessToken = viewModel.accessToken {
                        TokenView(title: "Access Token", token: accessToken)
                    }
                    
                    if let refreshToken = viewModel.refreshToken {
                        TokenView(title: "Refresh Token", token: refreshToken)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            
            Button(action: viewModel.logout) {
                Text("로그아웃")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct TokenView: View {
    let title: String
    let token: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(token)
                .font(.system(.caption, design: .monospaced))
                .lineLimit(2)
        }
    }
}

#Preview {
    AuthenticationView()
}


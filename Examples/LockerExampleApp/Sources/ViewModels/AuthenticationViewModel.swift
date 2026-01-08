//
//  AuthenticationViewModel.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Combine
import Locker

class AuthenticationViewModel: ObservableObject {
    private let storage = StorageManager.shared
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String?
    @Published var lastLoginDate: String?
    @Published var accessToken: String?
    @Published var refreshToken: String?
    @Published var errorMessage: String?
    
    var isLoginButtonEnabled: Bool {
        !email.isEmpty && !password.isEmpty
    }
    
    init() {
        checkLoginStatus()
    }
    
    func login() {
        // 실제 앱에서는 서버 API 호출
        // 여기서는 데모를 위해 가짜 토큰 생성
        let fakeAccessToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.\(UUID().uuidString)"
        let fakeRefreshToken = "refresh_\(UUID().uuidString)"
        
        do {
            // Keychain에 토큰 저장
            try storage.saveSecure(fakeAccessToken, forKey: "auth.accessToken")
            try storage.saveSecure(fakeRefreshToken, forKey: "auth.refreshToken")
            
            // UserDefaults에 사용자 정보 저장
            try storage.save(email, forKey: "auth.email")
            try storage.save(true, forKey: "auth.isLoggedIn")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let dateString = dateFormatter.string(from: Date())
            try storage.save(dateString, forKey: "auth.lastLoginDate")
            
            // 상태 업데이트
            isLoggedIn = true
            userEmail = email
            lastLoginDate = dateString
            accessToken = fakeAccessToken
            refreshToken = fakeRefreshToken
            errorMessage = nil
            
            // 입력 필드 초기화
            email = ""
            password = ""
        } catch {
            errorMessage = "로그인 실패: \(error.localizedDescription)"
        }
    }
    
    func logout() {
        do {
            // Keychain에서 토큰 삭제
            try storage.deleteSecure(forKey: "auth.accessToken")
            try storage.deleteSecure(forKey: "auth.refreshToken")
            
            // UserDefaults에서 사용자 정보 삭제
            try storage.delete(forKey: "auth.email")
            try storage.delete(forKey: "auth.isLoggedIn")
            try storage.delete(forKey: "auth.lastLoginDate")
            
            // 상태 초기화
            isLoggedIn = false
            userEmail = nil
            lastLoginDate = nil
            accessToken = nil
            refreshToken = nil
            errorMessage = nil
        } catch {
            errorMessage = "로그아웃 실패: \(error.localizedDescription)"
        }
    }
    
    private func checkLoginStatus() {
        do {
            isLoggedIn = (try storage.load(forKey: "auth.isLoggedIn")) ?? false
            
            if isLoggedIn {
                userEmail = try storage.load(forKey: "auth.email")
                lastLoginDate = try storage.load(forKey: "auth.lastLoginDate")
                accessToken = try storage.loadSecure(forKey: "auth.accessToken")
                refreshToken = try storage.loadSecure(forKey: "auth.refreshToken")
            }
        } catch {
            errorMessage = "상태 확인 실패: \(error.localizedDescription)"
        }
    }
}


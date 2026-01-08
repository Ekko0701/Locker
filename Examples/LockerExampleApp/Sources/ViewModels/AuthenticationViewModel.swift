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
    
    // 프로퍼티 래퍼를 사용한 간편한 Keychain 관리
    @Keychain(key: "auth.accessToken")
    private var storedAccessToken: String?
    
    @Keychain(key: "auth.refreshToken")
    private var storedRefreshToken: String?
    
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
            // 프로퍼티 래퍼 사용 - 자동으로 Keychain에 저장됨
            storedAccessToken = fakeAccessToken
            storedRefreshToken = fakeRefreshToken
            
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
            // 프로퍼티 래퍼 사용 - nil 할당 시 자동으로 Keychain에서 삭제
            storedAccessToken = nil
            storedRefreshToken = nil
            
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
                
                // 프로퍼티 래퍼 사용 - 자동으로 Keychain에서 로드
                accessToken = storedAccessToken
                refreshToken = storedRefreshToken
            }
        } catch {
            errorMessage = "상태 확인 실패: \(error.localizedDescription)"
        }
    }
}


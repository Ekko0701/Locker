//
//  KeychainViewModel.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import Foundation
import Combine
import Locker

class KeychainViewModel: ObservableObject {
    private let storage = StorageManager.shared
    
    @Published var accessTokenInput: String = ""
    @Published var refreshTokenInput: String = ""
    @Published var savedAccessToken: String?
    @Published var savedRefreshToken: String?
    @Published var errorMessage: String?
    
    init() {
        loadTokens()
    }
    
    func saveAccessToken() {
        guard !accessTokenInput.isEmpty else { return }
        
        do {
            try storage.saveSecure(
                accessTokenInput,
                forKey: "accessToken",
                accessibility: .afterFirstUnlock
            )
            savedAccessToken = accessTokenInput
            accessTokenInput = ""
            errorMessage = nil
        } catch {
            errorMessage = "액세스 토큰 저장 실패: \(error.localizedDescription)"
        }
    }
    
    func saveRefreshToken() {
        guard !refreshTokenInput.isEmpty else { return }
        
        do {
            try storage.saveSecure(
                refreshTokenInput,
                forKey: "refreshToken",
                accessibility: .afterFirstUnlock
            )
            savedRefreshToken = refreshTokenInput
            refreshTokenInput = ""
            errorMessage = nil
        } catch {
            errorMessage = "리프레시 토큰 저장 실패: \(error.localizedDescription)"
        }
    }
    
    func loadTokens() {
        do {
            savedAccessToken = try storage.loadSecure(forKey: "accessToken")
            savedRefreshToken = try storage.loadSecure(forKey: "refreshToken")
            errorMessage = nil
        } catch {
            errorMessage = "토큰 로드 실패: \(error.localizedDescription)"
        }
    }
    
    func deleteAllTokens() {
        do {
            try storage.deleteSecure(forKey: "accessToken")
            try storage.deleteSecure(forKey: "refreshToken")
            savedAccessToken = nil
            savedRefreshToken = nil
            errorMessage = nil
        } catch {
            errorMessage = "토큰 삭제 실패: \(error.localizedDescription)"
        }
    }
}


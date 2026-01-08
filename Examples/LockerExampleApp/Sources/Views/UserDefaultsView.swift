//
//  UserDefaultsView.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import SwiftUI
import Locker

struct UserDefaultsView: View {
    @StateObject private var viewModel = UserDefaultsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("테마 설정")) {
                    Toggle("다크 모드", isOn: $viewModel.isDarkMode)
                }
                
                Section(header: Text("폰트 설정")) {
                    HStack {
                        Text("폰트 크기")
                        Spacer()
                        Text("\(Int(viewModel.fontSize))")
                            .foregroundColor(.secondary)
                    }
                    Slider(value: $viewModel.fontSize, in: 10...30, step: 1)
                }
                
                Section(header: Text("알림 설정")) {
                    Toggle("알림 활성화", isOn: $viewModel.notificationsEnabled)
                }
                
                Section(header: Text("언어 설정")) {
                    Picker("언어", selection: $viewModel.language) {
                        Text("한국어").tag("ko")
                        Text("English").tag("en")
                        Text("日本語").tag("ja")
                    }
                }
                
                Section(header: Text("저장된 데이터")) {
                    VStack(alignment: .leading, spacing: 8) {
                        DataRow(title: "다크 모드", value: "\(viewModel.isDarkMode)")
                        DataRow(title: "폰트 크기", value: "\(Int(viewModel.fontSize))")
                        DataRow(title: "알림", value: "\(viewModel.notificationsEnabled)")
                        DataRow(title: "언어", value: viewModel.language)
                    }
                    .font(.system(.body, design: .monospaced))
                }
                
                Section {
                    Button(role: .destructive, action: viewModel.resetAll) {
                        HStack {
                            Image(systemName: "trash")
                            Text("모든 설정 초기화")
                        }
                    }
                }
            }
            .navigationTitle("UserDefaults 데모")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DataRow: View {
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

#Preview {
    UserDefaultsView()
}


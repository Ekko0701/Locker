//
//  ContentView.swift
//  LockerExampleApp
//
//  Created by 김동주 on 2026. 1. 8.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            UserDefaultsView()
                .tabItem {
                    Label("설정", systemImage: "gear")
                }
            
            KeychainDemoView()
                .tabItem {
                    Label("보안", systemImage: "lock.shield")
                }
            
            AuthenticationView()
                .tabItem {
                    Label("인증", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}


import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            SaveView()
                .tabItem {
                    Label("저장", systemImage: "square.and.arrow.down")
                }
            
            KeychainView()
                .tabItem {
                    Label("Keychain", systemImage: "key.fill")
                }
            
            UserDefaultsView()
                .tabItem {
                    Label("UserDefaults", systemImage: "gearshape.fill")
                }
            
            PropertyWrapperView()
                .tabItem {
                    Label("프로퍼티 래퍼", systemImage: "wand.and.stars")
                }
        }
    }
}

#Preview {
    ContentView()
}


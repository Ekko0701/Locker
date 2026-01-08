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
        }
    }
}

#Preview {
    ContentView()
}


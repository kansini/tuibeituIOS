//
//  tuibeituApp.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import SwiftUI
import SwiftData

@main
struct tuibeituApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(sharedModelContainer)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        NavigationView {
            HomeView()
        }
//        TabView {
//            NavigationView {
//                HomeView()
//            }
//            .tabItem {
//                Image(systemName: "house")
//                Text("首页")
//            }
//            NavigationView {
//                DiscoveryView()
//                    
//            }
//            .tabItem {
//                Image(systemName: "globe")
//                Text("发现")
//            }
//            
//            NavigationView {
//                SettingsView()
//                  
//            }
//            .tabItem {
//                Image(systemName: "person.circle")
//                Text("我的")
//            }
//        }
    }
}

#Preview {
    MainTabView()
}

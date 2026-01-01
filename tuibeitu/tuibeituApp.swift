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
            MainTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationView {
                ContentView()
                    .navigationTitle("首页")
            }
            .tabItem {
                Image(systemName: "house")
                Text("首页")
            }
            NavigationView {
                DiscoveryView()
                    .navigationTitle("发现")
            }
            .tabItem {
                Image(systemName: "discover")
                Text("发现")
            }
            
            NavigationView {
                SettingsView()
                    .navigationTitle("我的")
            }
            .tabItem {
                Image(systemName: "gear")
                Text("我的")
            }
        }
    }
}

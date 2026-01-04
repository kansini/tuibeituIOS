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
        }
    }
}

struct MainTabView: View {
    @State private var showContextView = false
    @State private var navigationPath = NavigationPath()
    @State private var homeViewCurrentIndex = 0
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color("BaseBg").ignoresSafeArea()
                
                VStack {
                    TopButtons(
                        onContextButtonTapped: {
                            showContextView = true
                        },
                        onSettingsButtonTapped: {
                            navigationPath.append("settings")
                        }
                    )
                    
                    HomeView(currentIndex: $homeViewCurrentIndex)
                }
                .navigationDestination(for: String.self) { destination in
                    switch destination {
                    case "settings":
                        SettingsView()
                    default:
                        EmptyView()
                    }
                }
            }
            .sheet(isPresented: $showContextView) {
                ContextView(currentIndex: $homeViewCurrentIndex, closeAction: { index in
                    homeViewCurrentIndex = index
                    showContextView = false
                })
            }
        }
    }
    struct TopButtons: View{
        // 新增函数：从Resources目录加载图标
        private func loadImageFromResources(named: String) -> UIImage? {
            // 尝试从 Resources/icons 目录加载图片
            let paths = [
                Bundle.main.path(forResource: named, ofType: "png", inDirectory: "Resources/icons"),
                Bundle.main.path(forResource: named, ofType: "png", inDirectory: "icons"),
                Bundle.main.path(forResource: named, ofType: "png")
            ]
            
            for path in paths {
                if let path = path, let image = UIImage(contentsOfFile: path) {
                    return image
                }
            }
            
            return nil
        }
        var onContextButtonTapped: () -> Void = {}
        var onSettingsButtonTapped: () -> Void = {}
        
        var body: some View{
            HStack {
                Spacer() // 推动按钮到右上角
                
                HStack {
                    Button(action: {
                        onContextButtonTapped()
                    }) {
                        Image(uiImage: loadImageFromResources(named: "context") ?? UIImage(systemName: "info.circle")!)
                            .resizable()
                            .frame(width: 16, height: 18)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 28, height: 28)
                    
                    Button(action: {
                        onSettingsButtonTapped()
                    }) {
                        Image(uiImage: loadImageFromResources(named: "settings") ?? UIImage(systemName: "gear")!)
                            .resizable()
                            .frame(width: 20, height: 18)
                            .foregroundColor(.primary)
                    }
                    .frame(width: 28, height: 28)
                }
                .padding(.trailing, 15)
                .padding(.top, 10)
            }
        }
    }
}
#Preview {
    MainTabView()
}

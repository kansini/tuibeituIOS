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
        ZStack{
            TopButtons()
            HomeView()
        }
        .frame(width: .infinity,height: .infinity)
        .background(Color(hex: "#EEDAB9")).ignoresSafeArea() // 设置页面背景色
        
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
        var body: some View{
            ZStack{
                HStack {
                    Button(action: {
                        print("Context button tapped")
                    }) {
                        Image(uiImage: loadImageFromResources(named: "context") ?? UIImage(systemName: "info.circle")!)
                            .resizable()
                            .frame(width: 20, height: 22)

                    }
                    .frame(width: 32, height: 32)
                    .cornerRadius(20)
                    
                    Button(action: {
                        print("Settings button tapped")
                    }) {
                        Image(uiImage: loadImageFromResources(named: "settings") ?? UIImage(systemName: "gear")!)
                            .resizable()
                            .frame(width: 24, height: 22)
                    }
                    .frame(width: 32, height: 32)
                    .cornerRadius(20)
                   
                }
            }
        }
    }
}

#Preview {
    MainTabView()
}

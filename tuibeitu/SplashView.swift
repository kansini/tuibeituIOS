//
//  SplashView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/2.
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            Color(hex: "#F5F2E9")
                .edgesIgnoringSafeArea(.all)
            
            if isActive {
                NavigationView {
                    HomeView()
                }
            } else {
                Image(uiImage: loadImage(named: "cover") ?? UIImage(systemName: "photo")!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .cornerRadius(16)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
    
    private func loadImage(named: String) -> UIImage? {
        // 尝试从 main bundle 加载图片
        if let image = UIImage(named: named) {
            return image
        }
        
        // 如果在 Assets 中找不到，尝试从 bundle 的其他路径加载
        let paths = [
            Bundle.main.path(forResource: named, ofType: "png", inDirectory: "resource/img"),
            Bundle.main.path(forResource: named, ofType: "png", inDirectory: "img"),
            Bundle.main.path(forResource: named, ofType: "png"),
            Bundle.main.path(forResource: named, ofType: nil)
        ]
        
        for path in paths {
            if let path = path, let image = UIImage(contentsOfFile: path) {
                return image
            }
        }
        
        // 如果所有方法都失败，返回 nil
        return nil
    }
}

#Preview {
    SplashView()
}

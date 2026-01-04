//
//  HomeView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import SwiftUI
import UIKit

struct HomeView: View {
    @State private var poemItems: [PoemItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    @Binding var currentIndex: Int
    @State private var offset = CGFloat.zero
    @State private var dragOffset = CGFloat.zero
    @State private var showingAnnotation = false
    @State private var selectedAnnotationIndex = 0
    @State private var annotationItems: [String] = []
    @State private var selectedAnnotationText = ""
    @State private var selectedSnText = ""
    @State private var annotationDataLoaded = false
    @State private var flippedCardIndex: Int? = nil
    @State private var isAnimating = false
    
    init(currentIndex: Binding<Int> = .constant(0)) {
        self._currentIndex = currentIndex
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("BaseBg").ignoresSafeArea()
                Group {
                    if isLoading {
                        VStack {
                            ProgressView("加载中...")
                            Text("正在加载数据...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    } else if let error = errorMessage {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("加载失败")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(error)
                                .foregroundColor(.secondary)
                                .font(.caption)
                            Button("重试") {
                                loadPoemData()
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding()
                    } else if poemItems.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "book.closed")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                            Text("暂无数据")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    } else {
                        TabView(selection: $currentIndex) {
                            ForEach(Array(poemItems.enumerated()), id: \.offset) { index, item in
                                VStack {
                                    // 添加状态变量用于点击反馈
                                    @State var isPressed = false
                                    
                                    FlipCardView(
                                        item: item,
                                        annotationText: getAnnotationText(for: index),
                                        isFlipped: flippedCardIndex == index,
                                        onFlip: {
                                            // 添加点击反馈效果
                                            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                                            impactFeedback.impactOccurred()
                                            
                                            // 翻转卡片
                                            if !isAnimating {
                                                isAnimating = true
                                                flippedCardIndex = flippedCardIndex == index ? nil : index
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                                    isAnimating = false
                                                }
                                            }
                                        }
                                    )
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding(.horizontal, 16)
                                
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onChange(of: currentIndex) { _, newValue in
                            // 当外部改变currentIndex时，确保动画过渡
                            currentIndex = min(max(0, newValue), poemItems.count - 1)
                        }
                        .background(Color("BaseBg"))  // 设置页面背景色
                    }
                }
                
               
            }
        }
        .navigationBarHidden(true) // 隐藏导航栏以移除顶部空白
        .onAppear {
            loadPoemData()
            // 检查是否已加载注解数据，如果没有则加载
            if !annotationDataLoaded {
                PoemDataLoader.loadAnnotationData { result in
                    switch result {
                    case .success(let annotations):
                        DispatchQueue.main.async {
                            annotationItems = annotations
                            annotationDataLoaded = true
                            print("成功加载 \(annotations.count) 项注解数据")
                        }
                    case .failure(let error):
                        print("预加载注解数据失败: \(error)")
                    }
                }
            }
        }
    }
    
    
    
    private func getCurrentIndexBasedOnOffset(offset: CGFloat, currentIndex: Int, totalItems: Int) -> Int {
        if offset < -100 { // 向上滑动，显示下一项
            return min(totalItems - 1, max(0, currentIndex + 1))
        } else if offset > 100 { // 向下滑动，显示上一项
            return min(totalItems - 1, max(0, currentIndex - 1))
        }
        return currentIndex
    }
    
    private func loadPoemData() {
        isLoading = true
        errorMessage = nil
        
        PoemDataLoader.loadPoemData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let items):
                    self.poemItems = items
                    self.isLoading = false
                    print("成功加载 \(items.count) 项数据")
                case .failure(let error):
                    self.errorMessage = "加载失败: \(error)"
                    self.isLoading = false
                }
            }
        }
    }
    
    private func getAnnotationText(for index: Int) -> String {
        if annotationDataLoaded && annotationItems.indices.contains(index) {
            return annotationItems[index]
        } else {
            return "注解数据加载中..."
        }
    }
}

// 改进的图像视图 - 专门用于加载PNG图片
struct ImageView: View {
    let imageName: String
    let figureNumber: Int
    
    @State private var imageNotFound = false
    @State private var shouldShowPlaceholder = true
    
    var body: some View {
        Group {
            if shouldShowPlaceholder {
                placeholderView()
            } else {
                imageFromBundle()
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        // 检查图片是否存在于bundle中
        if UIImage(named: imageName) != nil {
            // 图片存在，显示图片
            DispatchQueue.main.async {
                shouldShowPlaceholder = false
            }
        } else {
            // 图片不存在，保持占位符
            print("找不到图片: \(imageName)")
        }
    }
    
    private func imageFromBundle() -> some View {
        // 加载bundle中的图片
        if let uiImage = UIImage(named: imageName) {
            return AnyView(
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: 264)
                    .clipped()
                    .padding(.vertical, 16) // 添加上下padding 16
                    .background(Color(hex: "#F5F2E9"))
            )
        } else {
            // 如果图片不存在，返回占位符
            return AnyView(placeholderView())
        }
    }
    
    private func placeholderView() -> some View {
        ZStack {
            Rectangle()
                .fill(Color(hex: "#F5F2E9"))  // 使用新背景色
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                )
            
            VStack {
                Image(systemName: "photo.on.rectangle")
                    .font(.title)
                    .foregroundColor(.secondary)
                Text("图\(figureNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// 自定义按钮样式以实现点击反馈
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct PoemCardView: View {
    let item: PoemItem
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            // 显示对应图片
            ImageView(
                imageName: "figure\(getNumberFromSn(item.title.sn))",
                figureNumber: getNumberFromSn(item.title.sn)
            )
            .frame(height: 280)
            .clipped()
            .padding(.horizontal, -16) // 扩展到边缘
            .padding(.top, -16) // 与顶部对齐，移除负值
//            .padding(.vertical, 16) // 添加上下padding 16
               
            HStack(alignment: .top, spacing: 48) {
                // 描述内容
                if !item.poem.description.isEmpty {
                    HStack(alignment: .top, spacing:16 ){
                        ForEach(0..<item.poem.description.count, id: \.self) { i in
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(item.poem.description[i], id: \.self) { line in
                                    Text(line)
                                        .font(.fangzheng(size:20))
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 22)
                                }
                            }
                        }
                        Text("颂曰")
                            .font(.fangzheng(size:24))
                            .fontWeight(.bold)
                            .frame(width: 20)
                            
                    }
                    
                }
                HStack(alignment: .top, spacing:8 ){
                  // 预测内容
                    ForEach(0..<item.poem.predict.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(item.poem.predict[i], id: \.self) { line in
                                Text(line)
                                    .font(.fangzheng(size:20))
                                    .multilineTextAlignment(.leading)
                                    .frame(width: 20)
                            }
                        }
                    }
                    Text("谶曰")
                        .font(.fangzheng(size:24))
                        .fontWeight(.bold)
                        .frame(width: 24)
                }
                //标题内容
                VStack(spacing:4){
                    Rectangle()
                        .fill(Color("PrimaryRed"))
                        .frame(width: 36,height: 16)
                    VStack(spacing:16) {
                        
                        Text("第\(item.title.sn)象")
                            .font(.fangzheng(size:22))
                            .fontWeight(.bold)
                            .frame(width: 20)
                            .foregroundColor(.white)
                       
                        Text(item.title.ganZhi)
                            .font(.fangzheng(size:22))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20)
                       
                        Text(item.title.hexagrams1)
                            .font(.fangzheng(size:22))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20)
                       
                        Text(item.title.hexagrams2)
                            .font(.fangzheng(size:22))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20)
                        
                    }
                    .padding(.top,16)
                    .padding(.bottom,16)
                    .padding(.leading,8)
                    .padding(.trailing,8)
                    .background(Color("PrimaryRed"))
                    Rectangle()
                        .fill(Color("PrimaryRed"))
                        .frame(width: 36,height: 8)
                    
                }
                
                
               
            }
            .padding(.top, 8)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color(hex: "#08000000"), radius: 16,x: 8,y:8)
    }
    
    // 从中文数字获取阿拉伯数字
    private func getNumberFromSn(_ sn: String) -> Int {
        // 创建映射字典
        var numberMap: [String: Int] = [:]
        numberMap["一"] = 1
        numberMap["二"] = 2
        numberMap["三"] = 3
        numberMap["四"] = 4
        numberMap["五"] = 5
        numberMap["六"] = 6
        numberMap["七"] = 7
        numberMap["八"] = 8
        numberMap["九"] = 9
        numberMap["十"] = 10
        numberMap["十一"] = 11
        numberMap["十二"] = 12
        numberMap["十三"] = 13
        numberMap["十四"] = 14
        numberMap["十五"] = 15
        numberMap["十六"] = 16
        numberMap["十七"] = 17
        numberMap["十八"] = 18
        numberMap["十九"] = 19
        numberMap["二十"] = 20
        numberMap["二一"] = 21
        numberMap["二二"] = 22
        numberMap["二三"] = 23
        numberMap["二四"] = 24
        numberMap["二五"] = 25
        numberMap["二六"] = 26
        numberMap["二七"] = 27
        numberMap["二八"] = 28
        numberMap["二九"] = 29
        numberMap["三十"] = 30
        numberMap["三一"] = 31
        numberMap["三二"] = 32
        numberMap["三三"] = 33
        numberMap["三四"] = 34
        numberMap["三五"] = 35
        numberMap["三六"] = 36
        numberMap["三七"] = 37
        numberMap["三八"] = 38
        numberMap["三九"] = 39
        numberMap["四十"] = 40
        numberMap["四一"] = 41
        numberMap["四二"] = 42
        numberMap["四三"] = 43
        numberMap["四四"] = 44
        numberMap["四五"] = 45
        numberMap["四六"] = 46
        numberMap["四七"] = 47
        numberMap["四八"] = 48
        numberMap["四九"] = 49
        numberMap["五十"] = 50
        numberMap["五一"] = 51
        numberMap["五二"] = 52
        numberMap["五三"] = 53
        numberMap["五四"] = 54
        numberMap["五五"] = 55
        numberMap["五六"] = 56
        numberMap["五七"] = 57
        numberMap["五八"] = 58
        numberMap["五九"] = 59
        numberMap["六十"] = 60
        
        return numberMap[sn] ?? 1
    }
}

// 扩展Color以支持十六进制颜色值
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#Preview {
    HomeView()
}

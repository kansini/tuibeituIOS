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
    @State private var currentIndex = 0
    @State private var targetIndex = 0
    @State private var dragOffset = CGFloat.zero
    
    var body: some View {
        NavigationView {
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
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(Array(poemItems.enumerated()), id: \.offset) { index, item in
                                VStack {
                                    PoemCardView(item: item)
                                        .padding(.horizontal)
                                }
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .offset(y: (CGFloat(index - targetIndex) * geometry.size.height) + dragOffset)
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = gesture.translation.height
                                }
                                .onEnded { gesture in
                                    let velocity = gesture.velocity.height
                                    let threshold = geometry.size.height / 4 // 减小阈值以提高灵敏度
                                    
                                    // 计算新的目标索引
                                    var newIndex = targetIndex
                                    
                                    if dragOffset > threshold || (dragOffset > 0 && velocity > 1000) {
                                        // 向上滑动（内容向下移动），显示上一张卡片
                                        newIndex = max(0, targetIndex - 1)
                                    } else if dragOffset < -threshold || (dragOffset < 0 && velocity < -1000) {
                                        // 向下滑动（内容向上移动），显示下一张卡片
                                        newIndex = min(poemItems.count - 1, targetIndex + 1)
                                    }
                                    
                                    // 更新索引并重置偏移
                                    withAnimation {
                                        targetIndex = newIndex
                                        currentIndex = newIndex
                                    }
                                    
                                    dragOffset = 0
                                }
                        )
                    }
                    .background(Color(hex: "#EEDAB9"))  // 设置页面背景色
                }
            }
    
        }
        .onAppear {
            loadPoemData()
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
        
        DispatchQueue.global(qos: .userInitiated).async {
            // 检查 bundle 中的文件
            print("Bundle 路径: \(Bundle.main.bundlePath)")
            
            // 尝试多种可能的路径
            var jsonData: Data?
            var foundPath: String?
            
            let possiblePaths = [
                Bundle.main.path(forResource: "data/poem", ofType: "json"),
                Bundle.main.path(forResource: "poem", ofType: "json", inDirectory: "data"),
                Bundle.main.path(forResource: "poem", ofType: "json")
            ]
            
            for path in possiblePaths {
                if let filePath = path {
                    print("找到可能的路径: \(filePath)")
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) {
                        jsonData = data
                        foundPath = filePath
                        print("成功读取文件: \(filePath)")
                        break
                    } else {
                        print("读取失败: \(filePath)")
                    }
                }
            }
            
            if let data = jsonData {
                print("JSON 数据大小: \(data.count) 字节")
                
                // 打印前几个字符以检查格式
                if let jsonString = String(data: data.prefix(200), encoding: .utf8) {
                    print("JSON 前缀: \(jsonString)")
                }
                
                do {
                    let decoder = JSONDecoder()
                    // 设置日期格式等选项（如果需要）
                    let items = try decoder.decode([PoemItem].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.poemItems = items
                        self.isLoading = false
                        print("成功加载 \(items.count) 项数据，路径: \(foundPath ?? "unknown")")
                    }
                } catch let DecodingError.keyNotFound(key, context) {
                    let error = "解码错误 - 找不到键: \(key), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        self.errorMessage = error
                        self.isLoading = false
                    }
                } catch let DecodingError.valueNotFound(value, context) {
                    let error = "解码错误 - 找不到值: \(value), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        self.errorMessage = error
                        self.isLoading = false
                    }
                } catch let DecodingError.typeMismatch(type, context) {
                    let error = "解码错误 - 类型不匹配: \(type), 路径: \(context.codingPath), 详细信息: \(context.debugDescription)"
                    print(error)
                    DispatchQueue.main.async {
                        self.errorMessage = error
                        self.isLoading = false
                    }
                } catch let error as DecodingError {
                    print("解码错误: \(error)")
                    DispatchQueue.main.async {
                        self.errorMessage = "数据格式错误: \(error)"
                        self.isLoading = false
                    }
                } catch {
                    print("其他错误: \(error)")
                    DispatchQueue.main.async {
                        self.errorMessage = "加载失败: \(error)"
                        self.isLoading = false
                    }
                }
            } else {
                print("在bundle中找不到poem.json文件")
                
                // 如果无法从bundle加载，使用嵌入的数据
                DispatchQueue.main.async {
                    self.poemItems = embeddedPoemData
                    self.errorMessage = "使用嵌入数据（原文件未找到）"
                    self.isLoading = false
                    print("使用嵌入的示例数据")
                }
            }
        }
    }
    
    // 嵌入的示例数据
    private let embeddedPoemData: [PoemItem] = [
        PoemItem(
            title: Title(sn: "一", ganZhi: "甲子", hexagrams1: "乾下乾上", hexagrams2: "乾"),
            poem: Poem(
                predict: [["茫茫天地", "不知所止"], ["日月循环", "周而复始"]],
                description: [["自从盘古迄希夷", "虎斗龙争事正奇"], ["悟得循环真谛在", "试于唐后论元机"]]
            )
        ),
        PoemItem(
            title: Title(sn: "二", ganZhi: "乙丑", hexagrams1: "巽下乾上", hexagrams2: "姤"),
            poem: Poem(
                predict: [["累累硕果", "莫明其数"], ["一果一仁", "即新即故"]],
                description: [["万物土中生", "二九先成实"], ["一统定中原", "阴盛阳先竭"]]
            )
        ),
        PoemItem(
            title: Title(sn: "三", ganZhi: "丙寅", hexagrams1: "艮下乾上", hexagrams2: "遁"),
            poem: Poem(
                predict: [["日月当空", "照临下土"], ["扑朔迷离", "不文亦武"]],
                description: [["参遍空王色相空", "一朝重入帝王宫"], ["悟得循环真谛在", "喔喔晨鸡孰是雄"]]
            )
        )
    ]
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

struct PoemCardView: View {
    let item: PoemItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 显示对应图片
            ImageView(
                imageName: "figure\(getNumberFromSn(item.title.sn))",
                figureNumber: getNumberFromSn(item.title.sn)
            )
            .frame(height: 264)
            .clipped()
            .padding(.horizontal, -16) // 扩展到边缘
            .padding(.top, -32) // 与顶部对齐
            .padding(.vertical, 16) // 添加上下padding 16
        
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("第\(item.title.sn)象")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(item.title.ganZhi)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Text("卦辞: \(item.title.hexagrams2) (\(item.title.hexagrams1))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // 预测内容
                ForEach(0..<item.poem.predict.count, id: \.self) { i in
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(item.poem.predict[i], id: \.self) { line in
                            Text(line)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                
                // 描述内容
                if !item.poem.description.isEmpty {
                    Divider()
                    
                    ForEach(0..<item.poem.description.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(item.poem.description[i], id: \.self) { line in
                                Text(line)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
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

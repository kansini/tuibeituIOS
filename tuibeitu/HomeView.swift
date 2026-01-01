//
//  HomeView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import SwiftUI

struct HomeView: View {
    @State private var poemItems: [PoemItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
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
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(poemItems) { item in
                                PoemCardView(item: item)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("首页")
        }
        .onAppear {
            loadPoemData()
        }
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

struct PoemCardView: View {
    let item: PoemItem
    
    var body: some View {
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
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    HomeView()
}
//
//  ContextView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI

struct ContextView: View {
    @State private var poemItems: [PoemItem] = []
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    var closeAction: ((Int) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .frame(width: 40, height: 40)
                }
                .frame(width: 48, height: 48)
                
                Spacer()
            }
            .padding(.top, 8)
            .padding(.leading, -8)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 8) {
                    ForEach(Array(poemItems.enumerated()), id: \.offset) { index, item in
                        ContextItem(item: item, index: index, onButtonClick: { clickedIndex in
                            closeAction?(clickedIndex)
                        })
                    }
                }
            }
           
            
            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color("LightBg"))
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
                
               }
        }
    }
}


struct ContextItem: View{
    let item: PoemItem
    let index: Int
    let onButtonClick: (Int) -> Void
    @State var currentIndex: Int = 0
    
    var body: some View{
        Button(action: {
            onButtonClick(index)
            currentIndex = index
        }){
            Text("第\(item.title.sn)象")
                .font(.fangzheng(size:14))
                .frame(width: 18)
//                .foregroundColor(currentIndex === index ? .black : .white)
        }
        .padding(.horizontal,8)
        .padding(.vertical,12)
//        .background(currentIndex === index ? Color("PrimaryRed"):Color("CardBg"))
        .cornerRadius(20)
    }
}


#Preview {
    ContextView()
}

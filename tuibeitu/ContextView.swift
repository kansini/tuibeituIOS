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
    @Binding var currentIndex: Int
    var closeAction: ((Int) -> Void)?
    @Environment(\.dismiss) var dismiss
    
    init(currentIndex: Binding<Int>, closeAction: ((Int) -> Void)? = nil) {
        self._currentIndex = currentIndex
        self.closeAction = closeAction
    }
    
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Text("目录")
                    .font(.fangzheng(size: 24))
                Spacer()
                Button(action:{dismiss()}) {
                    Image(systemName: "xmark")
                       .foregroundColor(.primary)
                       .font(.title2)
                      }
                 }
            .padding(.bottom, 8)
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 8), spacing: 12) {
                    ForEach(Array(poemItems.enumerated()), id: \.offset) { index, item in
                        ContextItem(item: item, index: index, currentIndex: currentIndex, onButtonClick: { clickedIndex in
                            closeAction?(clickedIndex)
                        })
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color("LightBg"))
        .onAppear {
            loadPoemData()
        }
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
}


struct ContextItem: View{
    let item: PoemItem
    let index: Int
    let currentIndex: Int
    let onButtonClick: (Int) -> Void
    
    var body: some View{
        Button(action: {
            onButtonClick(index)
        }){
            Text( index == 9 ? "第\(item.title.sn)〇象" : index > 8 ? "第\(item.title.sn)象" : "第〇\(item.title.sn)象")
                .font(.fangzheng(size:13))
                .frame(width: 13)
                .foregroundColor(currentIndex == index ? .white : .black)
        }
        .padding(.horizontal,8)
        .padding(.vertical,12)
        .background(currentIndex == index ? Color("PrimaryRed"):Color("CardBg"))
        .cornerRadius(20)
    }
}


//#Preview {
//    ContextView()
//}

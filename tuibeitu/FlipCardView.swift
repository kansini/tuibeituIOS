//
//  FlipCardView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/4.
//

import SwiftUI

// MARK: - 导入模型和扩展
struct FlipCardView: View {
    let item: PoemItem
    let annotationText: String
    let isFlipped: Bool
    let onFlip: () -> Void
    
    var body: some View {
        ZStack {
            // 卡片背面 - 注解内容
            if isFlipped {
                AnnotationCardView(annotationText: annotationText, sn: item.title.sn, item: item)
                    .background(Color("LightBg"))
//                    .opacity(0.85)
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
            
            // 卡片正面 - 诗词内容
            if !isFlipped {
                PoemCardContentView(item: item)
                    .background(Color(.systemBackground))
//                    .opacity(0.85)
            }
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .onTapGesture {
            onFlip()
        }
            .cornerRadius(12)
            .shadow(color: Color(hex: "#0F000000"), radius: 16, x: 8, y: 8)
            .animation(.easeInOut(duration: 0.3), value: isFlipped) // 添加动画效果
    }
}

// 诗词卡片内容视图（不包含容器样式，只包含内容）
struct PoemCardContentView: View {
    let item: PoemItem
    
    var body: some View {
        ScrollView() {
            VStack(alignment: .trailing, spacing: 8) {
                // 显示对应图片
                ImageView(
                    imageName: "figure\(getNumberFromSn(item.title.sn))",
                    figureNumber: getNumberFromSn(item.title.sn)
                )
                .frame(height: 296)
                
                HStack(alignment: .top) {
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
                    Spacer()
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
                    Spacer()
                    //标题内容
                    VStack(spacing:4){
                        Rectangle()
                            .fill(Color("PrimaryRed"))
                            .frame(width: 36,height: 16)
                        VStack(spacing:12) {
                            
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
                        .padding(.vertical,12)
                        .padding(.horizontal,8)
                        .background(Color("PrimaryRed"))
                        Rectangle()
                            .fill(Color("PrimaryRed"))
                            .frame(width: 36,height: 8)
                        
                    }
                    
                    
                    
                }
                .padding(.vertical, 8)
                .padding(.trailing, 16)
                .padding(.leading, 48)
            }
        }
    }
}

// 用于显示注解的卡片视图
struct AnnotationCardView: View {
    let annotationText: String
    let sn: String
    let item: PoemItem
    
    var body: some View {
        ScrollView() {
           VStack(spacing:16){
               ZStack{
                   Text("第\(sn)象")
                       .font(.fangzheng(size: 20))
                       .foregroundColor(Color.white)
                       .padding(.horizontal,16)
                       .padding(.top, 4)
                       .padding(.bottom, 8)
                       .background(Color("PrimaryRed"))
                       .cornerRadius(20)
               }
                   .frame(maxWidth: .infinity, alignment: .center)
                VStack(spacing:8){
                    Text("谶曰")
                        .font(.hancheng(size:22))
                        .fontWeight(.bold)
                    ForEach(0..<item.poem.predict.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(item.poem.predict[i], id: \.self) { line in
                                Text(line)
                                    .font(.fangzheng(size:18))
                                    .multilineTextAlignment(.leading)
                            }
                        }
                    }
                }
                VStack(spacing:8){
                    Text("颂曰")
                        .font(.hancheng(size:22))
                        .fontWeight(.bold)
                    ForEach(0..<item.poem.description.count, id: \.self) { i in
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(item.poem.description[i], id: \.self) { line in
                                Text(line)
                                    .font(.fangzheng(size:18))
                                    .multilineTextAlignment(.leading)
                                    
                            }
                        }
                    }
                    
                }
                VStack(spacing:8){
                    Text("注解")
                        .font(.hancheng(size:22))
                        .fontWeight(.bold)
                    Text(annotationText)
                        .font(.fangzheng(size: 18))
                        .lineSpacing(8)
                        .frame(alignment: .leading)
                }
                .padding(.horizontal, 24)
            }
        }
        .padding()
    }
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

//struct FlipCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleItem = PoemItem(
//            title: Title(sn: "一", ganZhi: "甲子", hexagrams1: "乾", hexagrams2: "坤"),
//            poem: Poem(
//                predict: [["谶曰", "此象主", "国家"]],
//                description: [["颂曰", "此象主", "国家"]]
//            )
//        )
//        
//        FlipCardView(
//            item: sampleItem,
//            annotationText: "这是注解内容，用于解释诗词的含义。这是注解内容，用于解释诗词的含义。",
//            isFlipped: false,
//            onFlip: {}
//        )
//        .previewInterfaceOrientation(.portrait)
//    }
//}

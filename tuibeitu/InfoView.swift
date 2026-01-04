//
//  InfoView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/4.
//

import SwiftUI


struct InfoView: View {
    let infotext:String = "「推背图」是唐李淳风与袁天罡所著的一本预言奇书，以六十象卦图结合谶语、颂诗，推测自唐以降的国运兴衰，被誉为中国古代谶纬文化的代表作。每象融合《周易》卦象、隐晦诗文和图像，以玄妙方式揭示历史更迭与天道循环，其名源于末象“不如推背去归休”之句。\n 书中内容历经宋、明等朝代篡改和禁毁，版本混乱，真伪难辨，却持续影响中国政治文化与民间想象。它不仅反映古人对历史规律的符号化思考，更成为乱世中人们解读时局的隐喻载体。现代学者多视其为托古之作，侧重从文献学、符号学角度分析其文本结构和社会心理投射功能。"
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
           ScrollView{
               Text(infotext)
                    .font(.fangzheng(size: 20))
                    .lineSpacing(12)
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .principal) {
                        Text("简介")
                            .font(.fangzheng(size: 24))
                            }
                        }
            .navigationBarItems(leading: Button(action:{dismiss()}) {
                Image(systemName: "xmark")
                   .foregroundColor(.primary)
                   .frame(width: 16, height: 16)
            }
            .frame(width: 24, height: 24)
            .cornerRadius(40))
        }
    }
}

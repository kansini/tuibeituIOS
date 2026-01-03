//
//  AnnotationView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI

struct AnnotationView: View {
    let annotationText: String
    let sn: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("第\(sn)象")
                    .font(.fangzheng(size: 24))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                   
                Text(annotationText)
                    .font(.fangzheng(size: 20))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .lineSpacing(16)
                
               }
            .padding()
        }
        .background(Color("LightBg"))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(annotationText: "这是一个示例注解文本。", sn: "一")
    }
}

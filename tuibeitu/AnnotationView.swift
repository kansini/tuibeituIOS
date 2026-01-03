//
//  AnnotationView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI

struct AnnotationView: View {
    let annotationText: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(annotationText)
                        .font(.fangzheng(size: 20))
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .lineSpacing(16)
                    
//                    Spacer()
                }
                .padding()
            }
            .background(Color("LightBg"))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("注解")
                        .font(.fangzheng(size: 28, fontWeight: .bold))
                }
            }
            .navigationBarItems(leading: Button(action:{presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "xmark")
                   .foregroundColor(.primary)
                   .frame(width: 16, height: 16)
            }
            .frame(width: 24, height: 24)
            .cornerRadius(40))
        }
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(annotationText: "这是一个示例注解文本。")
    }
}

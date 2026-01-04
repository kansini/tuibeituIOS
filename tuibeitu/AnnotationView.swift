//
//  AnnotationView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI
import UIKit

struct AnnotationView: View {
    let annotationText: String
    let sn: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("第\(sn)象")
                    .font(.fangzheng(size: 22))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                Text(annotationText)
                    .font(.fangzheng(size: 20))
                    .lineSpacing(8)
                    .frame(maxWidth: .infinity, alignment: .leading)

                   
//                UITextViewWrapper(text: annotationText, fontSize: 20, lineSpacing: 16)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .fixedSize(horizontal: false, vertical: true)
                
               }
            .padding()
        }
        .background(Color("LightBg"))
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

struct UITextViewWrapper: UIViewRepresentable {
    let text: String
    let fontSize: CGFloat
    let lineSpacing: CGFloat

    init(text: String, fontSize: CGFloat = 20, lineSpacing: CGFloat = 16) {
        self.text = text
        self.fontSize = fontSize
        self.lineSpacing = lineSpacing
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()

        // 设置文本属性
        textView.isEditable = false
        textView.isSelectable = true
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.backgroundColor = UIColor.clear
        textView.text = text
        textView.font = UIFont(name: "FZFangSong-Z02", size: fontSize)
        textView.dataDetectorTypes = []

        // 设置自动换行
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // 设置行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = .left

        // 应用字体和段落样式到整个文本
        let attributedString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "FZFangSong-Z02", size: fontSize)
        attributedString.addAttribute(.font, value: font ?? UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: text.utf16.count))
//        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.utf16.count))

        textView.attributedText = attributedString

        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        uiView.font = UIFont(name: "FZFangSong-Z02", size: fontSize)

        // 设置自动换行
        uiView.textContainer.lineFragmentPadding = 0
        uiView.textContainerInset = .zero
        uiView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        // 更新行间距
        let style = NSMutableParagraphStyle()
        style.lineSpacing = lineSpacing
        style.alignment = .left

        // 应用字体和段落样式到整个文本
        let attributedString = NSMutableAttributedString(string: text)
        let font = UIFont(name: "FZFangSong-Z02", size: fontSize)
        attributedString.addAttribute(.font, value: font ?? UIFont.systemFont(ofSize: fontSize), range: NSRange(location: 0, length: text.utf16.count))
//        attributedString.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.utf16.count))
        
        uiView.attributedText = attributedString
    }
}

struct AnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        AnnotationView(annotationText: "这是一个示例注解文本。这是一个示例注解文本。这是一个示例注解文本。这是一个示例注解文本。这是一个示例注解文本。这是一个示例注解文本。", sn: "一")
    }
}

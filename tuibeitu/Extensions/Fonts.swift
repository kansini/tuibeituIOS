//
//  Fonts.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI
extension Font{
    static func fangzheng(size: CGFloat = 20, fontWeight:Weight = .bold) -> Font{
        return Font.custom("FZFangSong-Z02", size: size).weight(fontWeight)
    }
    static func hancheng(size: CGFloat = 20, fontWeight:Weight = .bold) -> Font{
        return Font.custom("HCZWST2024", size: size).weight(fontWeight)
    }
}
//extension Font.TextStyle{
//    var size: CGFloat{
//        switch self{
//        case .largeTitle: return 34
//        case .title: return 30
//        case .title2: return 22
//        case .title3: return 20
//        case .headline: return 18
//        case .body: return 16
//        case .callout: return 15
//        case .subheadline: return 14
//        case .footnote: return 13
//        case .caption: return 12
//        case .caption2: return 11
//        @unknown default: return 8
//        }
//    }
//}

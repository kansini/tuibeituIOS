//
//  ContextView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/3.
//

import SwiftUI

struct ContextView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.primary)
                    }
                    .frame(width: 44, height: 44)
                    
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
                
                VStack(alignment: .center) {
                    Text("应用信息")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.bottom)
                    
                    Text("版本: 1.0.0")
                        .padding(.vertical, 4)
                    Text("作者: s s Flood")
                        .padding(.vertical, 4)
                    Text("© 2026 tuibeitu. All rights reserved.")
                        .padding(.vertical, 4)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            .padding(.horizontal, 24)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ContextView()
}
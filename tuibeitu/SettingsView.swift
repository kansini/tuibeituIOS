//
//  SettingView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import SwiftUI
struct SettingsView: View {
    var body: some View {
        List {
            Section {
                NavigationLink {
                    Text("通用设置")
                } label: {
                    Text("主题模式")
                        .font(.fangzheng(size: 16))
                }

                NavigationLink {
                    Text("关于应用")
                } label: {
                    Text("字体设置")
                        .font(.fangzheng(size: 16))
                }
            }
            
            Section {
                NavigationLink {
                    Text("关于应用")
                } label: {
                    Text("关于")
                        .font(.fangzheng(size: 16))
                }
                NavigationLink {
                    Text("隐私协议")
                } label: {
                    Text("隐私协议")
                        .font(.fangzheng(size: 16))
                }
            }
        }
        .navigationTitle("设置")
    }
}
#Preview {
    SettingsView()
}


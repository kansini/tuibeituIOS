//
//  SettingView.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import SwiftUI
struct DiscoveryView: View {
    var body: some View {
        List {
                Section() {
                    NavigationLink {
                        Text("通用设置")
                    } label: {
                        Text("通用")
                    }

                    NavigationLink {
                        Text("关于应用")
                    } label: {
                        Text("关于")
                    }
                }
                    NavigationLink {
                        Text("隐私协议")
                    } label: {
                        Text("隐私协议")
                    }
                }
            }

    }


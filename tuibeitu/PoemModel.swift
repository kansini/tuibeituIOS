//
//  PoemModel.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import Foundation

struct PoemItem: Codable, Identifiable {
    let id = UUID()
    let title: Title
    let poem: Poem
}

struct Title: Codable {
    let sn: String
    let ganZhi: String
    let hexagrams1: String
    let hexagrams2: String
}
    
struct Poem: Codable {
    let predict: [[String]]
    let description: [[String]]
}
//
//  Item.swift
//  tuibeitu
//
//  Created by s s Flood on 2026/1/1.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var label:String
    
    init(timestamp: Date) {
        self.timestamp = timestamp
        self.label = "test"
    }
}

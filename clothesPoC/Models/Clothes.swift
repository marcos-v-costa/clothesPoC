//
//  Clothes.swift
//  clothesPoC
//
//  Created by marquiros on 13/08/26.
//

import SwiftUI
import SwiftData
 
@Model
class Clothes {
    var id = UUID()
    var title: String
    var type: ClothesResult
    var image: Data?

    init(title: String,
         type: ClothesResult,
         image: Data? = nil) {
        self.title = title
        self.type = type
        self.image = image
    }
}

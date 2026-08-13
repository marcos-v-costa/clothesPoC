//
//  ClothesResult.swift
//  MyClothes
//
//  Created by marquiros on 07/08/26.
//

import Foundation
import SwiftUI
import SwiftData

enum ClothesResult: String, Identifiable, CaseIterable, Equatable, Sendable, Codable {
    var id: Self { self }
    case calca
    case sapato
    case camisa
    
    var displayClothes: String {
        switch self {
        case .calca: "Calça"
        case .sapato: "Sapato"
        case .camisa: "Camisa"
        }
    }
    
}

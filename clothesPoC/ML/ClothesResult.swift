//
//  ClothesResult.swift
//  MyClothes
//
//  Created by marquiros on 07/08/26.
//

import Foundation
import SwiftUI

enum ClothesResult: String, CaseIterable, Equatable, Sendable {
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

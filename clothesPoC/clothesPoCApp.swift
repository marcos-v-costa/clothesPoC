//
//  clothesPoCApp.swift
//  clothesPoC
//
//  Created by marquiros on 08/08/26.
//

import SwiftUI
import SwiftData

@main
struct clothesPoCApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Clothes.self])

    }
}

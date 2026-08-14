//
//  ContentView.swift
//  clothesPoC
//
//  Created by marquiros on 08/08/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Clothes.title) var clothes: [Clothes]
    @State var showAddTaskSheet: Bool = false

    let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        NavigationStack {
            Group {
                if clothes.isEmpty {
                    Text("Nenhuma roupa cadastrada")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 32) {
                            ForEach(clothes) { clothes in
                                NavigationLink(destination: ClothesDetailView(clothes: clothes)) {
                                    ClothesRow(clothes: clothes)
                                }
                                .buttonStyle(.plain)
                                .contextMenu {
                                    Button(role: .destructive) {
                                        modelContext.delete(clothes)
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        .padding(32)
                    }
                }
            }
            .navigationTitle("Roupas")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showAddTaskSheet.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddTaskSheet) {
                AddPhoto(clothes: [])
            }
        }
    }
}

#Preview {
    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Clothes.self, configurations: configuration)
    ContentView()
        .modelContainer(container)
}

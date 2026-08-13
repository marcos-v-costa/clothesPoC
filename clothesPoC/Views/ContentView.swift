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
    
    var body: some View {
        NavigationStack {
            VStack {
                if !clothes.isEmpty {
                    List {
                        ForEach(clothes) { clothes in
                            NavigationLink {
                                ClothesDetailView(clothes: clothes)
                            } label: {
                                Image(systemName: "book.fill")
                                VStack(alignment: .leading){
                                    Text(clothes.title)
                                        .font(.headline)
                                }
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    modelContext.delete(clothes)
                                }
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button(action: {
                                showAddTaskSheet.toggle()
                            }) {
                                Image(systemName: "plus")
                            }
                        }
                    }
                    .navigationTitle("Roupas")
                }
                else {
                    Text("Nenhuma roupa cadastrada").font(.title).bold(true)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button(action: {
                                    showAddTaskSheet.toggle()
                                }) {
                                    Image(systemName: "plus")
                                }
                            }
                        }
                        .navigationTitle("Pra fazer")
                }
            }
            .sheet(isPresented: $showAddTaskSheet) {
                AddPhoto(clothes: [])
            }
        }
    }}

#Preview {
    ContentView()
}

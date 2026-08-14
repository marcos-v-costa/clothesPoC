//
//  ClothesDetailView.swift
//  clothesPoC
//
//  Created by marquiros on 13/08/26.
//

import SwiftUI

struct ClothesDetailView: View {
    
    let clothes: Clothes
    
    var body: some View {
        List {
            Section(header: Text("Roupa")){
                if let data = clothes.image {
                    if let uiImage = UIImage(data: data) {
                        HStack(alignment: .center){
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 300, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .clipped()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: 500)
                    }
                    
                } else {
                    HStack(alignment: .center) {
                        Image(systemName: "photo.fill")
                            .font(.largeTitle)
                            .frame(width: 300, height: 200)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            Section(header: Text("Categoria")) {
                Text(clothes.title)
            }
        }
        .navigationTitle(clothes.title)
    }
}

#Preview {
    NavigationStack {
        ClothesDetailView(clothes: Clothes(title: "calça", type: .calca))
    }
}

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
            if let data = clothes.image {
                if let uiImage = UIImage(data: data) {
                    HStack(alignment: .center){
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 300, height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                            .clipped()
                    }
                    .frame(maxWidth: .infinity)
                }
            } else {
                HStack(alignment: .center) {
                    Image(systemName: "photo.fill")
                        .font(.largeTitle)
                        .frame(width: 150, height: 200)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
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

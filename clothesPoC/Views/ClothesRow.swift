//
//  ClothesRow.swift
//  clothesPoC
//
//  Created by marquiros on 13/08/26.
//

import SwiftUI

struct ClothesRow: View {
    let clothes: Clothes
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let data = clothes.image {
                if let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 100)
                }
            } else {
                Image(systemName: "photo.fill")
                    .font(.largeTitle)
                    .frame(width: 150, height: 200)
                    .background(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .foregroundColor(.white)
                    .shadow(radius: 100)
            }
         
        }
    }
}

#Preview {
    HStack (spacing: 36){
        ClothesRow(clothes: Clothes(title: "Camisa", type: .calca))
        ClothesRow(clothes: Clothes(title: "Camisa", type: .calca))
    }

}

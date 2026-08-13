//
//  PhotoPickerUI.swift
//  clothesPoC
//
//  Created by marquiros on 10/08/26.
//

import SwiftUI
import UIKit
import PhotosUI
import SwiftData

struct PhotoPickerUI: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: Image?
    @State private var clothesTitle: String = ""
    
    let clothes: [Clothes]
    var clothesType: ClothesResult = .calca
    
    let model = ClothesClassificationService()
    
    var body: some View {
        NavigationStack{
            VStack {
                PhotosPicker(selection: $selectedItem,
                             matching: .images,
                             photoLibrary: .shared()) {
                    HStack{
                        HStack(spacing: 14){
                            Image(systemName: "photo.badge.plus")
                                .font(.system(size: 24))
                            Text("Pegar da galeria")
                                .bold()
                            Spacer()
                            
                        }
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 28)
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 16).fill(.white))
                    .shadow(radius: 100)
                    .foregroundStyle(Color.black)
                    .padding()
                }
//                HStack{
//                    HStack(spacing: 12){
//                        Image(systemName: "camera")
//                            .font(.system(size: 24))
//                        Text("Tirar foto")
//                            .bold()
//                        Spacer()
//                        
//                    }
//                    Image(systemName: "chevron.right")
//                }
//                .padding(.horizontal, 24)
//                .padding(.vertical, 28)
//                .frame(maxWidth: .infinity)
//                .background(RoundedRectangle(cornerRadius: 16).fill(.white))
//                .shadow(radius: 100)
//                .foregroundStyle(Color.black)
//                .padding()
            }
        }
        
        .onChange(of: selectedItem) { _,_ in
            Task {
                if let loaded = try? await selectedItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: loaded),
                   let cgImage = uiImage.cgImage {
                    
                    photo = Image(uiImage: uiImage)
                    
                    let capturedImage = CapturedImage(
                        cgImage: cgImage,
                        orientation: uiImage.imageOrientation.cgImagePropertyOrientation
                    )
                    
                    if let result = try? await model.classify(capturedImage) {
                        clothesTitle = result.roupa.displayClothes
                        print(result)
                        print(capturedImage)
                    }
                }
            }
        }
   
    }
    
}

#Preview {
    @Previewable @State var clothes: [Clothes] = []

    PhotoPickerUI(clothes: clothes)
}

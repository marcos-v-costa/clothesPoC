//
//  PhotoPickerUI.swift
//  clothesPoC
//
//  Created by marquiros on 10/08/26.
//

import SwiftUI
import UIKit
import PhotosUI

struct PhotoPickerUI: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: Image?
    @State private var clothesTitle: String = ""
    
    let model = ClothesClassificationService()
    
    var body: some View {
        VStack {
            PhotosPicker(selection: $selectedItem,
                         matching: .images,
                         photoLibrary: .shared()) {
                Text("Escolher roupa")
                    .bold()
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 16).fill(.black))
            }
            
            photo?
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
            Text(clothesTitle)
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
    PhotoPickerUI()
}

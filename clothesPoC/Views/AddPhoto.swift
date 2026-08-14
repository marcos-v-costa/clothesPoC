//
//  AddPhoto.swift
//  clothesPoC
//
//  Created by marquiros on 13/08/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddPhoto: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State var clothesTitle: String = ""
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: Data? = nil
    @State var clothesCategory: ClothesResult = .calca
    
    let clothes: [Clothes]
    let model = ClothesClassificationService()
    let backgroundRemoval = BackgroundRemovalService()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Selecionar roupa")) {
                    PhotosPicker(selection: $selectedItem, matching: .images) {

                            if let photo, let uiImage = UIImage(data: photo) {
                                HStack(alignment: .center) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 300)
                                        .frame(maxWidth: .infinity)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .frame(maxWidth: .infinity)
                            } else {
                                HStack(alignment: .center) {
                                    Image(systemName: "photo.badge.plus.fill")
                                        .font(.largeTitle)
                                        .frame(height: 200)
                                        .frame(maxWidth: .infinity)
                                        .background(Color(white: 0.4, opacity: 0.2))
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                }
                                .frame(maxWidth: .infinity)
                            }
                        
                    }
                    
                    .listRowBackground(Color.clear)
                    .onChange(of: selectedItem) { _,_ in
                        Task {
                            if let loaded = try? await selectedItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: loaded),
                               let cgImage = uiImage.cgImage {
                                
                                let capturedImage = CapturedImage(
                                    cgImage: cgImage,
                                    orientation: uiImage.imageOrientation.cgImagePropertyOrientation
                                )
                                    let cutoutCGImage = try backgroundRemoval.removeBackground(capturedImage)
                                    let cutoutImage = UIImage(cgImage: cutoutCGImage)
                                    photo = cutoutImage.pngData()
                                
                                if let result = try? await model.classify(capturedImage) {
                                    clothesTitle = result.roupa.displayClothes
                                    print(result)
                                    print(capturedImage)
                                }
                            }
                        }
                    }
                }
                Section(header: Text("Título")) {
                    Text(clothesTitle)
                }
                
                
            }
            .toolbar {
                ToolbarItem (placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem (placement: .title) {
                    Text("Adicionar roupa")
                }
                
                ToolbarItem (placement: .confirmationAction) {
                    Button {
                        addClothes()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                    }
                    .disabled(clothesTitle.isEmpty)
                }
            }
        }
    }
    
    func addClothes() {
        let newClothes = Clothes(title: clothesTitle, type: clothesCategory, image: photo)
        modelContext.insert(newClothes)
    }
    
}

#Preview {
    @Previewable var clothes: [Clothes] = []
    AddPhoto(clothes: clothes)
}

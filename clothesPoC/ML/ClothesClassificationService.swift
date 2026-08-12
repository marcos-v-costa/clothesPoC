//
//  ClothesClassificationService.swift
//  clothesPoC
//
//  Created by marquiros on 08/08/26.
//

import CoreML
import Foundation
import Vision
import UIKit

struct CapturedImage: @unchecked Sendable {
    let cgImage: CGImage
    let orientation: CGImagePropertyOrientation
}

enum ClassificationError: Error {
    case message(String)
}

struct ClassificationResult: Equatable {
    let roupa: ClothesResult
    let confidence: Double
}

class ClothesClassificationService {
    let confidenceThreshold: Double
    
    init(confidenceThreshold: Double = 0.85) {
        self.confidenceThreshold = confidenceThreshold
    }
    
    func classify(_ image: CapturedImage) async throws -> ClassificationResult {
        let mlModel = try loadModel()
        let visionModel = try adaptModelToVision(mlModel)
        let request = makeClassificationRequest(using: visionModel)
        let observations = try performRequest(request, on: image)
        return try interpret(observations)
    }
    
    private func loadModel() throws -> MLModel {
        guard let modelURL = Bundle.main.url(
            forResource: "MyClothesClassificationML",
            withExtension: "mlmodelc"
        ) else {
            throw ClassificationError.message("O arquivo do modelo não foi encontrado no bundle.")
        }
        do {
            return try MLModel(contentsOf: modelURL)
        } catch {
            throw ClassificationError.message("O modelo não pôde ser carregado: \(error.localizedDescription)")
        }
    }
    
    private func adaptModelToVision(_ mlModel: MLModel) throws -> VNCoreMLModel {
        do {
            return try VNCoreMLModel(for: mlModel)
        } catch {
            throw ClassificationError.message("O modelo não pôde ser adaptado para o Vision: \(error.localizedDescription)")
        }
    }
    
    private func makeClassificationRequest(using visionModel: VNCoreMLModel) -> VNCoreMLRequest {
        let request = VNCoreMLRequest(model: visionModel)
        request.imageCropAndScaleOption = .centerCrop
        return request
    }
    
    private func performRequest(
        _ request: VNCoreMLRequest,
        on image: CapturedImage
    ) throws -> [VNClassificationObservation] {
        let handler = VNImageRequestHandler(
            cgImage: image.cgImage,
            orientation: image.orientation,
            options: [:]
        )
        
        do {
            try handler.perform([request])
        } catch {
            throw ClassificationError.message("A imagem não pôde ser analisada: \(error.localizedDescription)")
        }
        
        guard let rawResults = request.results else {
            throw ClassificationError.message("O modelo não retornou nenhum resultado.")
        }
        guard let observations = rawResults as? [VNClassificationObservation] else {
            throw ClassificationError.message("O modelo retornou um tipo de resultado inesperado. Confirme que ele é um classificador de imagens.")
        }
        return observations
    }
    
    private func interpret(_ observations: [VNClassificationObservation]) throws -> ClassificationResult {
        let predictions = observations.map {
            (identifier: $0.identifier, confidence: $0.confidence)
        }
        
        return try Self.interpretPredictions(predictions)
    }
    
    static func interpretPredictions(
        _ predictions: [(identifier: String, confidence: Float)]
    ) throws -> ClassificationResult {
        
        guard let best = predictions.max(by: { $0.confidence < $1.confidence }) else {
            throw ClassificationError.message("O modelo não retornou uma previsão. Tente outra imagem.")
        }
        guard let roupa = ClothesResult(rawValue: best.identifier) else {
            throw ClassificationError.message("O modelo retornou um rótulo não suportado “\(best.identifier)”. Verifique os nomes das classes do modelo.")
        }
        
        return ClassificationResult(roupa: roupa, confidence: Double(best.confidence))
    }
    
}

extension UIImage.Orientation {
    var cgImagePropertyOrientation: CGImagePropertyOrientation {
        switch self {
        case .up: .up
        case .down: .down
        case .left: .left
        case .right: .right
        case .upMirrored: .upMirrored
        case .downMirrored: .downMirrored
        case .leftMirrored: .leftMirrored
        case .rightMirrored: .rightMirrored
        @unknown default: .up
        }
    }
}

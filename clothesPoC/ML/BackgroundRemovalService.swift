//
//  BackgroundRemovalService.swift
//  clothesPoC
//
//  Created by marquiros on 13/08/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import UIKit
import Vision

enum BackgroundRemovalError: Error {
    case message(String)
}

class BackgroundRemovalService {

    private let context = CIContext()

    func removeBackground(_ image: CapturedImage) throws -> CGImage {
        let inputImage = CIImage(cgImage: image.cgImage).oriented(image.orientation)

        let mask = try createMask(from: inputImage)
        let outputImage = applyMask(mask, to: inputImage)

        guard let cgImage = context.createCGImage(outputImage, from: inputImage.extent) else {
            throw BackgroundRemovalError.message("Não foi possível gerar a imagem final sem fundo.")
        }

        return cgImage
    }

    private func createMask(from inputImage: CIImage) throws -> CIImage {
        let request = VNGenerateForegroundInstanceMaskRequest()
        let handler = VNImageRequestHandler(ciImage: inputImage)

        do {
            try handler.perform([request])
        } catch {
            throw BackgroundRemovalError.message("Não foi possível analisar a imagem: \(error.localizedDescription)")
        }

        guard let result = request.results?.first else {
            throw BackgroundRemovalError.message("Nenhum objeto principal foi identificado na imagem.")
        }

        do {
            let maskPixelBuffer = try result.generateScaledMaskForImage(
                forInstances: result.allInstances,
                from: handler
            )
            return CIImage(cvPixelBuffer: maskPixelBuffer)
        } catch {
            throw BackgroundRemovalError.message("Não foi possível gerar a máscara: \(error.localizedDescription)")
        }
    }

    private func applyMask(_ mask: CIImage, to image: CIImage) -> CIImage {
        let filter = CIFilter.blendWithMask()
        filter.inputImage = image
        filter.maskImage = mask
        filter.backgroundImage = CIImage.empty()
        return filter.outputImage ?? image
    }
}

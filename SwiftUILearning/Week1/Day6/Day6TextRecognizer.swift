//
//  Day6TextRecognizer.swift
//  SwiftUILearning
//
//  Created by 오정석 on 2/11/2025.
//

import SwiftUI
import Vision
import VisionKit

class TextRecognizer {
    func recognizeText(in image: UIImage) async throws -> [String] {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "Invalud", code: 0)
        }
        
        let request = VNRecognizeTextRequest()
        request.recognitionLevel = .accurate
        request.recognitionLanguages = ["ko-KR", "en-US"]
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        
        guard let observations = request.results else {
            return []
        }
        
        return observations.compactMap { observation in
            observation.topCandidates(1).first?.string
        }
    }
}

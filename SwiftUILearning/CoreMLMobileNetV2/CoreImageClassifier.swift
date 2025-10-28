//
//  CoreImageClassifier.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import Vision
import CoreML
import UIKit
import Combine

class CoreImageClassifier: ObservableObject {
    private let model = try? VNCoreMLModel(for: MobileNetV2().model)
    
    @Published var resultLabel: String = ""
    @Published var confidence: Float = 0
    
    func classify(image: UIImage) {
        guard let model = model else { return }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else { return }
            
            print("분류: \(topResult.identifier)")
            print("확률: \(topResult.confidence)")
            DispatchQueue.main.async {
                self.resultLabel = topResult.identifier
                self.confidence = topResult.confidence
            }
        }
        
        guard let ciImage = CIImage(image: image) else { return}
        let handler = VNImageRequestHandler(ciImage: ciImage)
        try? handler.perform([request])
    }
}

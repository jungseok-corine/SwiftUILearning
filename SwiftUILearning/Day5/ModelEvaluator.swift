//
//  ModelEvaluator.swift
//  SwiftUILearning
//
//  Created by 오정석 on 31/10/2025.
//

import CoreML
import CreateMLComponents
import SwiftUI
import Vision


class ModelEvaluator {
    struct EvaluationResult {
        let accuracy: Double
        let precision: Double
        let recall: Double
        let f1Score: Double
        let confusionMatrix: [[Int]]
    }
    
    // 정확도 계산
    func calculateAccuracy(predictions: [String], labels: [String]) -> Double {
        let correct = zip(predictions, labels).filter { $0 == $1 }.count
        return Double(correct) / Double(labels.count)
    }
    
    // Precision 계산 (정밀도)
    func calculatePrecision(truePositives: Int, falsePositives: Int) -> Double {
        guard (truePositives + falsePositives) > 0 else { return 0}
        return Double(truePositives) / Double(truePositives + falsePositives)
    }
    
    // Recall 계산 (재현율)
    func calculateRecall(truePositives: Int, falseNegatives: Int) -> Double {
        guard (truePositives + falseNegatives) > 0 else { return 0}
        return Double(truePositives) / Double(truePositives + falseNegatives)
    }
    
    // F1 Score 계산
    func calculateF1Score(precision: Double, recall: Double) -> Double {
        guard (precision + recall) > 0 else { return 0}
        return 2 * (precision * recall) / (precision + recall)
    }
    
    // 테스트 데이터로 평가
    func evaluate(model: MLModel, testImages: [(UIImage, String)]) async -> EvaluationResult {
        var predictions: [String] = []
        var labels: [String] = []
        
        for (image, label) in testImages {
            if let prediction = await classifyImage(model: model, image: image) {
                predictions.append(prediction)
                labels.append(label)
            }
        }
        
        let accuracy = calculateAccuracy(predictions: predictions, labels: labels)
        
        // 여기서는 간단히 accuracy만 계산
        // 실제로는 confusion matrix를 먼저 계산하고 precision, recall 등을 구함
        
        return EvaluationResult(
            accuracy: accuracy,
            precision: 0.0,
            recall: 0.0,
            f1Score: 0.0,
            confusionMatrix: [])
    }
    
    private func classifyImage(model: MLModel, image: UIImage) async -> String? {
        
        // 1. Core ML 모델을 Vision 모델로 변환
        guard let visionModel = try? VNCoreMLModel(for: model) else {
            return nil
        }
        
        // 2. UIImage -> CIImage 변환
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // 3. Vision Request 실행 (async/await 사용!)
        return await withCheckedContinuation { continuation in
            let request = VNCoreMLRequest(model: visionModel) { request, error in
                guard let results = request.results as? [VNClassificationObservation],
                      let topResult = results.first else {
                    continuation.resume(returning: nil)
                    return
                }
                continuation.resume(returning: topResult.identifier)
            }
            
            let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    func measurePredictionTime(model: MLModel, image: UIImage) async -> (prediction: String?, time: TimeInterval) {
        let startTime = Date()
        let prediction = await classifyImage(model: model, image: image)
        let elapsedTime = Date().timeIntervalSince(startTime)
        
        return(prediction, elapsedTime)
    }
}

//
//  ImageClassifierViewModel.swift
//  SwiftUILearning
//
//  Created by 오정석 on 31/10/2025.
//

import SwiftUI
import CoreML
import Vision
import Observation

@Observable
class ImageClassifierViewModel {
    var selectedImage: UIImage?
    var prediction: String = "이미지를 선택하세요"
    var confidence: Double = 0.0
    var predictionTime: Double = 0.0
    var isLoading = false
    
    func classifyImage() {
        guard let image = selectedImage else { return }
        isLoading = true
        
        // 시작 시간 기록
        let startTime = Date()
        
        // 1. Core ML 모델 로드
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            prediction = "모델 로드 실패"
            isLoading = false
            return
        }
        
        // 2. Vision Request 생성
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            // 경과 시간 계산
            let elapsedTime = Date().timeIntervalSince(startTime)
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first else {
                self?.prediction = "분류 실패"
                self?.isLoading = false
                return
            }
            
            DispatchQueue.main.async {
                self?.prediction = topResult.identifier
                self?.confidence = Double(topResult.confidence)
                self?.predictionTime = elapsedTime * 1000 // 밀리초로 변환
                self?.isLoading = false
            }
        }
        
        // 3. 이미지 처리
        guard let ciImage = CIImage(image: image) else {
            prediction = "이미지 변환 실패"
            isLoading = false
            return
        }
        
        // 4. 예측 실행
        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        DispatchQueue.global(qos: .userInitiated).async {
            try? handler.perform([request])
        }
    }
}


//
//  Day6FaceDetector.swift
//  SwiftUILearning
//
//  Created by 오정석 on 2/11/2025.
//

import Vision
import Observation
import UIKit


class FaceDetector {
    func detectFace(in image: UIImage) async throws -> [VNFaceObservation] {
        guard let cgImage = image.cgImage else {
            throw NSError(domain: "Invalid image", code: 0)
        }
        
        let request = VNDetectFaceRectanglesRequest()
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        try handler.perform([request])
        
        guard let observations = request.results else {
            return []
        }
        
        return observations
    }
}


// View에서 사용
@Observable
class FaceDetectionViewModel {
    var selectedImage: UIImage?
    var faceCount = 0
    var isDetecting = false
    
    func detectFaces() {
        guard let image = selectedImage else { return }
        isDetecting = true
        
        Task {
            let detector = FaceDetector()
            let faces = try? await detector.detectFace(in: image)
            
            await MainActor.run {
                self.faceCount = faces?.count ?? 0
                self.isDetecting = false
            }
        }
    }
}

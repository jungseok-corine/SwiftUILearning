//
//  CoreUI.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI
import PhotosUI

struct CoreUI: View {
    @EnvironmentObject var classifier: CoreImageClassifier
    
    @State private var pickedItem: PhotosPickerItem?
    @State private var uiImage: UIImage?
    
    var body: some View {
        VStack(spacing: 16) {
            PhotosPicker(selection: $pickedItem, matching: .images) {
                Text("사진 선택하기")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .onChange(of: pickedItem) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        uiImage = image
                    }
                }
            }
            
            if let image = uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Button("분류하기") {
                    classifier.classify(image: image)
                }
                .buttonStyle(.borderedProminent)
            }
            
            if !classifier.resultLabel.isEmpty {
                VStack(spacing: 6) {
                    Text("결과: \(classifier.resultLabel)")
                        .font(.title3).bold()
                    Text(String(format: "신뢰도: %.1f%%", classifier.confidence * 100))
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("CoreML 분류기")
    }
}

#Preview {
    NavigationStack {
        CoreUI()
    }
    .environmentObject(CoreImageClassifier())   // ✅ 프리뷰용 더미 주입
}

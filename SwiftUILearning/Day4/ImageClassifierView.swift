//
//  ImageClassifierView.swift
//  SwiftUILearning
//
//  Created by 오정석 on 31/10/2025.
//

import SwiftUI

struct ImageClassifierView: View {
    @State private var viewModel = ImageClassifierViewModel()
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 이미지 표시
            if let image = viewModel.selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                    .overlay {
                        Text("이미지를 선택하세요")
                            .foregroundStyle(.secondary)
                    }
            }
            
            // 예측 결과
            VStack(alignment: .leading, spacing: 8) {
                Text("예측 결과")
                    .font(.headline)
                
                HStack {
                    Text(viewModel.prediction)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    if viewModel.confidence > 0 {
                        Text("\(Int(viewModel.confidence * 100))%")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
            
            // 버튼들
            VStack(spacing: 12) {
                Button(action: { showingImagePicker = true }) {
                    Label("이미지 선택", systemImage: "photo.on.rectangle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                Button(action: viewModel.classifyImage) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Label("분류하기", systemImage: "wand.and.stars")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.selectedImage == nil || viewModel.isLoading)
            }
        }
        .padding()
        .navigationTitle("이미지 분류")
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(image: $viewModel.selectedImage)
        }
    }
}

// PhotosPicker 래퍼
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider,
                  provider.canLoadObject(ofClass: UIImage.self) else { return }
            
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.parent.image = image as? UIImage
                }
            }
        }
    }
}
#Preview {
    ImageClassifierView()
}

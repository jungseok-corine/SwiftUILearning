//
//  SentimentAnalysis.swift
//  SwiftUILearning
//
//  Created by 오정석 on 4/11/2025.
//

import SwiftUI

// MARK: - ViewModel

@Observable
class SentimentAnalysisViewModel {
    var inputText = ""
    var result: SentimentResult?
    var isAnalyzing = false
    
    private let analyzer = SentimentAnalyzer()
    
    func analyze() {
        guard !inputText.isEmpty else { return }
        
        isAnalyzing = true
        
        // 비동기 처리 (UI 반응성 유지)
        Task {
            // 약간의 지연 (분석 중 표시)
            try? await Task.sleep(for: .milliseconds(500))
            
            let analysisResult = analyzer.analyze(text: inputText)
            
            await MainActor.run {
                result = analysisResult
                isAnalyzing = false
            }
        }
    }
    
    func clear() {
        inputText = ""
        result = nil
    }
}


// MARK: - View

struct SentimentAnalysisView: View {
    @State private var viewModel = SentimentAnalysisViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 입력 영역
                    VStack(alignment: .leading, spacing: 8) {
                        Text("영화 리뷰를 입력하세요")
                            .font(.headline)
                        
                        TextEditor(text: $viewModel.inputText)
                            .frame(height: 120)
                            .padding(8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .overlay {
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            }
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: viewModel.analyze) {
                            if viewModel.isAnalyzing {
                                HStack {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .tint(.white)
                                    Text("분석 중...")
                                        .foregroundStyle(.white)
                                }
                            } else {
                                Text("감정 분석")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                        .disabled(viewModel.inputText.isEmpty || viewModel.isAnalyzing)
                        
                        Button("초기화", action: viewModel.clear)
                            .buttonStyle(.bordered)
                    }
                    
                    // 결과
                    if let result = viewModel.result {
                        VStack(spacing: 20) {
                            // 메인 결과
                            VStack(spacing: 16) {
                                // 이모지
                                Text(sentimentEmoji(result.sentiment))
                                    .font(.system(size: 80))
                                
                                // 감정
                                Text(result.sentiment)
                                    .font(.title)
                                    .bold()
                                
                                // 확신도
                                VStack(spacing: 8) {
                                    Text("\(Int(result.confidence * 100))% 확신")
                                        .font(.headline)
                                        .foregroundStyle(.secondary)
                                    
                                    ProgressView(value: result.confidence)
                                        .tint(sentimentColor(result.sentiment))
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(sentimentColor(result.sentiment).opacity(0.1))
                            .cornerRadius(16)
                            
                            // 상세 점수
                            VStack(alignment: .leading, spacing: 12) {
                                Text("상세 점수")
                                    .font(.headline)
                                
                                ForEach(result.allScores.sorted(by: { $0.value > $1.value }), id: \.key) { key, value in
                                    HStack {
                                        Text(key)
                                            .frame(width: 60, alignment: .leading)
                                        
                                        ProgressView(value: value)
                                            .tint(sentimentColor(key))
                                        
                                        Text("\(Int(value * 100))%")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                            .frame(width: 40, alignment: .trailing)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    
                    // 예시
                    if viewModel.result == nil {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("예시 리뷰:")
                                .font(.headline)
                            
                            ExampleButton(text: "정말 재미있어요! 강추!", onTap: {
                                viewModel.inputText = "정말 재미있어요! 강추!"
                            })
                            
                            ExampleButton(text: "시간 낭비였어요", onTap: {
                                viewModel.inputText = "시간 낭비였어요"
                            })
                            
                            ExampleButton(text: "그냥 평범해요", onTap: {
                                viewModel.inputText = "그냥 평범해요"
                            })
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationTitle("감정 분석")
        }
    }
    
    // MARK: - Helper Functions
    
    private func sentimentEmoji(_ sentiment: String) -> String {
        switch sentiment {
        case "긍정": return "😊"
        case "부정": return "😢"
        case "중립": return "😐"
        default: return "🤔"
        }
    }
    
    private func sentimentColor(_ sentiment: String) -> Color {
        switch sentiment {
        case "긍정": return .green
        case "부정": return .red
        case "중립": return .gray
        default: return .blue
        }
    }
}

// MARK: - Example Button

struct ExampleButton: View {
    let text: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(text)
                    .foregroundStyle(.primary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(8)
        }
    }
}

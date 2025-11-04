//
//  SentimentAnalyzer.swift
//  SwiftUILearning
//
//  Created by 오정석 on 4/11/2025.
//

import Foundation
import CoreML
import NaturalLanguage

/// 감정 분석 결과
struct SentimentResult {
    let sentiment: String  // 긍정, 부정, 중립
    let confidence: Double // 0.0 ~ 1.0
    let allScores: [String: Double] // 모든 카테고리별 점수
}

/// 감정 분서기
class SentimentAnalyzer {
    // MARK: - Properties
    
    private var model: MovieSentimentClassifier_1?
    // MARK: - Initialization
    
    init() {
        do {
            model = try MovieSentimentClassifier_1(configuration: MLModelConfiguration())
            print("✅ 감정 분석 모델 로드 성공")
        } catch {
            print("❌ 모델 로드 실패: \(error)")
        }
    }
    
    // MARK: - Public Methods
    
    /// 텍스트의 감정 분석
    /// - Parameter text: 분석할 텍스트
    /// - Returns: 감정 분석 결과
    func analyze(text: String) -> SentimentResult? {
        guard let model = model else {
            print("❌ 모델이 로드되지 않음")
            return nil
        }
        
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("⚠️ 빈 텍스트")
            return nil
        }
        
        do {
                    let prediction = try model.prediction(text: text)
                    let sentiment = prediction.label
                    
                    // ⭐️ 방법 1: labelProbability가 있는 경우
                    if let scores = try? getLabelProbability(from: prediction) {
                        let confidence = scores[sentiment] ?? 0.0
                        print("📊 분석 결과: \(sentiment) (\(Int(confidence * 100))%)")
                        
                        return SentimentResult(
                            sentiment: sentiment,
                            confidence: confidence,
                            allScores: scores
                        )
                    }
                    
                    // ⭐️ 방법 2: labelProbability가 없는 경우 (기본값 사용)
                    else {
                        print("⚠️ 확률 정보 없음, 기본값 사용")
                        print("📊 분석 결과: \(sentiment) (확률 정보 없음)")
                        
                        // 기본 확률 값 생성
                        let defaultScores = generateDefaultScores(for: sentiment)
                        
                        return SentimentResult(
                            sentiment: sentiment,
                            confidence: 1.0,  // 100% 확신으로 표시
                            allScores: defaultScores
                        )
                    }
                } catch {
                    print("❌ 예측 실패: \(error)")
                    return nil
                }
            }
            
            // MARK: - Helper Methods
            
            /// labelProbability 가져오기 (리플렉션 사용)
            private func getLabelProbability(from prediction: Any) throws -> [String: Double]? {
                let mirror = Mirror(reflecting: prediction)
                
                for child in mirror.children {
                    if child.label == "labelProbability" {
                        return child.value as? [String: Double]
                    }
                }
                
                return nil
            }
            
            /// 기본 확률 값 생성
            private func generateDefaultScores(for sentiment: String) -> [String: Double] {
                // 선택된 감정에 높은 확률, 나머지는 낮은 확률
                let categories = ["긍정", "부정", "중립"]
                var scores: [String: Double] = [:]
                
                for category in categories {
                    if category == sentiment {
                        scores[category] = 1.0  // 100%
                    } else {
                        scores[category] = 0.0  // 0%
                    }
                }
                
                return scores
            }
        }

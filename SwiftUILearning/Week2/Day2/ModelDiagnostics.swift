//
//  ModelDiagnostics.swift
//  SwiftUILearning
//
//  Created by 오정석 on 4/11/2025.
//

import Foundation

#if DEBUG
import CoreML

enum ModelDiagnostics {
    static func run() {
        do {
            let wrapper = try MovieSentimentClassifier_1(configuration: .init())
            let desc = wrapper.model.modelDescription

            print("▶ Output keys:", Array(desc.outputDescriptionsByName.keys))

            for (k, v) in desc.outputDescriptionsByName {
                print(" -", k, v)
            }

            // 원시 예측도 찍어보기
            let core = wrapper.model
            let input = try MLDictionaryFeatureProvider(dictionary: ["text": "정말 재밌어요!"])
            let out = try core.prediction(from: input)

            print("▶ raw label:", out.featureValue(for: "label")?.stringValue ?? "nil")
            print("▶ raw probs(labelProbabilities):", out.featureValue(for: "labelProbabilities")?.dictionaryValue ?? [:])
            print("▶ raw probs(classProbability):",  out.featureValue(for: "classProbability")?.dictionaryValue ?? [:])

        } catch {
            print("❌ ModelDiagnostics error:", error)
        }
    }
}
#endif

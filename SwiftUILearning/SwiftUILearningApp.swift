//
//  SwiftUILearningApp.swift
//  SwiftUILearning
//
//  Created by 오정석 on 23/10/2025.
//

import SwiftUI

@main
struct SwiftUILearningApp: App {
//    @StateObject private var classifier = FlowerClassifier()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {          // navigationTitle 쓰니 감싸주면 좋아요
                ImageClassifierView()
            }
//            .environmentObject(classifier)
        }
    }
}

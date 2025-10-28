//
//  BindingSlider.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI

struct BindingSlider: View {
    @State private var count: Double = 5.0
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Slider(
                value: $count,
                in: 0...10) {
                    Text("Binding Slider")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("10")
                } onEditingChanged: { editing in
                    isEditing = editing
                }
                .padding(.horizontal)
            
            Text("Value: \(count)")
                .foregroundStyle(isEditing ? .red : .blue)
        }
    }
}

#Preview {
    BindingSlider()
}

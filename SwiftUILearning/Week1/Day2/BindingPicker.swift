//
//  BindingPicker.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI

struct BindingPicker: View {
    @State var options: [String] = ["사과", "바나나", "자두", "샤인머스켓", "곶감"]
    @State var selecetedNumber: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            List {
                Picker("Fruit Select", selection: $selecetedNumber) {
                    ForEach(0..<options.count) { index in
                        Text(options[index])
                    }
                }
                Text("선택한 과일: \(options[selecetedNumber])")
            }
        }
    }
}

#Preview {
    BindingPicker()
}

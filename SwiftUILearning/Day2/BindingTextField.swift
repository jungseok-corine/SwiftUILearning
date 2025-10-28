//
//  BindingTextField.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI

struct BindingTextField: View {
    @State private var text: String = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter text", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Text("Text: \(text)")
                
                NavigationLink(destination: BindingTextField2(text: $text)) {
                    Text("MoveToBindingTextField2")
                } //:NavLink
            } //: VStack
        }//: Navigation
    }
}

struct BindingTextField2: View {
    @Binding var text: String
    var body: some View {
        Text(text)
            .font(.largeTitle)
    }
}

#Preview {
    BindingTextField()
}

//
//  BindingInter.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI

struct BindingInter: View {
    @State var count: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("\(count)")
                    .font(.largeTitle)
                Button("+") {
                    count += 1
                }
                .buttonStyle(.borderedProminent)
                
                NavigationLink(destination: BindingInter2(count: $count)) {
                    Text("Move To BindingInter2")
                }
            }
        }
        .navigationTitle("Binding Study")
    }
}

struct BindingInter2: View {
    @Binding var count: Int
    
    var body: some View {
        Text("\(count)")
            .font(.largeTitle)

        Button("+") {
            count += 1
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    BindingInter()
}

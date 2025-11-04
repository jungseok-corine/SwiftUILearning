//
//  StateCounterView.swift
//  SwiftUILearning
//
//  Created by 오정석 on 27/10/2025.
//

import SwiftUI

struct StateCounterView: View {
    @State var count: Int = 0
    @State private var countColor: Color = .black
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Count: \(count)")
                .font(.title)
                .foregroundStyle(countColor)
                .animation(.spring, value: count)
            
            HStack(spacing: 20) {
                Button("카운트 업") {
                    count += 1
                    countColor = count < 0 ? .red : .blue
                }
                .buttonStyle(.borderedProminent)
                
                Button  {
                    // action
                    count -= 1
                    countColor = count < 0 ? .red : .blue
                } label: {
                    // label
                    Text("카운트 다운")
                }
                .buttonStyle(.bordered)
            } //:HSTACK
            
            Button("reset") {
                withAnimation {
                    count = 0
                    countColor = .black
                }
            }
            .buttonStyle(.bordered)
            
        } //:VSTACK
    }
}

#Preview {
    StateCounterView()
}

//
//  TodoList.swift
//  SwiftUILearning
//
//  Created by 오정석 on 28/10/2025.
//

import SwiftUI

struct TodoListModel: Identifiable {
    let id: String = UUID().uuidString
    var title: String
    var description: String
    
    static let example = [
        TodoListModel(title: "@binding", description: "겁나 여럽다"),
        TodoListModel(title: "no2. todo", description: "no2 todo"),
        TodoListModel(title: "no3. todo", description: "no3 todo"),
        TodoListModel(title: "no4. todo", description: "no4 todo"),
        TodoListModel(title: "no5. todo", description: "no5 todo"),
        TodoListModel(title: "no6. todo", description: "no6 todo")
    ]
    
}

struct TodoList: View {
    @State var todos: [TodoListModel] = TodoListModel.example
    var body: some View {
        NavigationView {
           
            List {
                ForEach(todos) { item in
                    HStack{
                        Text(item.title)
                            .font(.headline)
                        Spacer()
                        Text(item.description)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("ToDoList")
        }
    }
}

#Preview {
    TodoList()
}

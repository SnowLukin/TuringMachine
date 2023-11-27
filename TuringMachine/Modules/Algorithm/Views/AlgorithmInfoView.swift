//
//  AlgorithmInfoView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 25.11.2023.
//

import SwiftUI

struct AlgorithmInfoView: View {

    enum Focus {
        case name
        case description
    }

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @FocusState private var focus: Focus?

    @ObservedObject var algorithm: CDAlgorithm
    @State private var nameInput = ""
    @State private var descriptionInput = ""

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Name")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .alignHorizontally(.leading)
                    TextField("Placeholder", text: $nameInput)
                        .focused($focus, equals: .name)
                        .padding()
                        .background(Color.secondaryBackground, in: .rect(cornerRadius: 10))
                }

                VStack {
                    Text("Description")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .alignHorizontally(.leading)
                    TextEditor(text: $descriptionInput)
                        .scrollContentBackground(.hidden)
                        .focused($focus, equals: .description)
                        .padding()
                        .background(Color.secondaryBackground, in: .rect(cornerRadius: 10))
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 10)
            .navigationTitle("Algorithm info")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focus = nil
                    }
                }
            }
        }
        .onAppear(perform: {
            nameInput = algorithm.name.unwrapped
            descriptionInput = algorithm.algDescription.unwrapped
        })
        .onChange(of: nameInput, perform: { newValue in
            try? algorithm.updateInfo(with: newValue, in: context)
        })
        .onChange(of: descriptionInput, perform: { newValue in
            try? algorithm.updateInfo(description: newValue, in: context)
        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return AlgorithmInfoView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

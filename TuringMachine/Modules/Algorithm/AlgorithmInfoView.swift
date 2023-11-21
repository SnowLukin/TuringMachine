//
//  AlgorithmInfoView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct AlgorithmInfoView: View {

    enum Focus {
        case name
        case description
    }

    @ObservedObject var algorithm: Algorithm

    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var context
    @FocusState private var focus: Focus?
    @State private var name: String = ""
    @State private var description: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Name") {
                    TextField("Placeholder", text: $name)
                        .focused($focus, equals: .name)
                }

                Section("Description") {
                    TextEditor(text: $description)
                        .focused($focus, equals: .description)
                }
            }
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
            .onChange(of: name, perform: updateName)
            .onChange(of: description, perform: updateDescription)
            .onAppear {
                name = algorithm.name.unwrapped
                description = algorithm.algDescription.unwrapped
            }
        }
    }

    private func updateName(_ newName: String) {
        if newName.count > 20 {
            name = String(name.prefix(20))
            return
        }
        if newName == algorithm.name { return }
        algorithm.name = newName
        updateAlgorithm()
    }

    private func updateDescription(_ newDescription: String) {
        if newDescription == algorithm.algDescription { return }
        algorithm.algDescription = description
        updateAlgorithm()
    }
    
    private func updateAlgorithm() {
        algorithm.lastEditDate = Date.now
        try? context.save()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CoreDataFetcher.shared.fetchEntities(
        ofType: Algorithm.self,
        withPredicate: nil,
        in: context
    )[0]
    return AlgorithmInfoView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}


//
//  StateListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 22.11.2023.
//

import SwiftUI

struct StateListView: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var algorithm: CDAlgorithm
    @State private var showAddingAlert = false
    @State private var searchText = ""

    var states: [CDMachineState] {
        searchText.isEmpty
        ? algorithm.unwrappedStates
        : algorithm.unwrappedStates.filter({ $0.name.unwrapped.contains(searchText) })
    }

    var body: some View {
        List {
            ForEach(states) { state in
                NavigationLink {
                    StateView(state: state)
                } label: {
                    Text(state.name.unwrapped)
                }
                .buttonStyle(.plain)
                .deleteDisabled(states.count <= 1)
            }
            .onDelete(perform: deleteStates)
        }
        .searchable(text: $searchText)
        .alert("New state", isPresented: $showAddingAlert) {
            TextFieldAlert(placeholder: "State \(states.count)") { stateName in
                addState(with: stateName)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") { showAddingAlert.toggle() }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .navigationTitle("States")
    }

    func addState(with name: String) {
        withAnimation {
            try? CDMachineState.create(name: name, algorithm: algorithm, in: context)
        }
    }

    func deleteStates(offsets: IndexSet) {
        withAnimation {
            let statesForDeletion = offsets.map { states[$0] }
            for state in statesForDeletion {
                try? algorithm.removeState(state)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return NavigationStack {
        StateListView(algorithm: algorithm)
            .environment(\.managedObjectContext, context)
    }
}

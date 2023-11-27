//
//  OptionListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct StateView: View {
    @Environment(\.managedObjectContext) private var context

    @ObservedObject var state: CDMachineState

    @State private var searchedOption = ""
    @State private var showNewOptionAlert = false

    private var options: [CDOption] {
        searchedOption.isEmpty
        ? state.unwrappedOptions
        : state.unwrappedOptions.filter {
            $0.joinedCombinations.contains(searchedOption)
        }
    }

    var body: some View {
        List {
            ForEach(options) { option in
                NavigationLink {
                    OptionView(option: option)
                } label: {
                    Text(option.joinedCombinations)
                }.buttonStyle(.plain)
            }.onDelete(perform: deleteOptions)
        }
        .searchable(text: $searchedOption)
        .navigationTitle("\(state.name ?? "State")'s combinations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Add") {
                showNewOptionAlert.toggle()
            }
        }
        .alert("New Combination", isPresented: $showNewOptionAlert) {
            TextFieldAlert(placeholder: "") { text in
                try? CDOption.create(combinations: text, state: state, in: context)
            }
        } message: {
            Text("Enter new combination")
        }
    }

    private func deleteOptions(_ offsets: IndexSet) {
        let selectedOptions = offsets.map { options[$0] }
        for option in selectedOptions {
            try? state.removeOption(option)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let state = CDMachineState.findAll(in: context)[0]
    return NavigationView {
        StateView(state: state)
    }.environment(\.managedObjectContext, context)
}

//
//  OptionListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct CombinationListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var state: StateQ
    let stateIndex: Int
    
    @State private var searchedCombination = ""

    private var options: [Option] {
        searchedCombination.isEmpty
        ? state.unwrappedOptions
        : state.unwrappedOptions.filter {
            $0.unwrappedCombinations
                .map { $0.fromChar.unwrapped }
                .joined(separator: "")
                .contains(searchedCombination)
        }
    }

    var body: some View {
        List(options) { option in
            NavigationLink {
                
            } label: {
                Text(combinationString(for: option))
            }.buttonStyle(.plain)
        }
        .searchable(text: $searchedCombination)
        .navigationTitle("State \(stateIndex)'s combinations")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Add") {

            }
        }
    }

    private func combinationString(for option: Option) -> String {
        option.unwrappedCombinations
            .map { $0.toChar.unwrapped }
            .joined(separator: "")
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let state = CoreDataFetcher.shared.fetchEntities(
        ofType: StateQ.self,
        withPredicate: nil,
        in: context
    )[0]
    return NavigationStack {
        CombinationListView(state: state, stateIndex: 0)
            .environment(\.managedObjectContext, context)
    }
}

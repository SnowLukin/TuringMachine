//
//  StartStateListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct StartStateListView: View {

    @ObservedObject var algorithm: Algorithm
    @Environment(\.managedObjectContext) private var context
    
    private var states: [StateQ] {
        algorithm.unwrappedStates
    }

    var body: some View {
        List {
            ForEach(states.indices, id: \.self) { index in
                Text("State \(index)")
                    .foregroundColor(.primary)
                    .selectable(algorithm.startingStateId == states[index].id)
                    .onTapGesture {
                        changeStartState(to: states[index])
                    }
            }
        }
        .navigationTitle("Current state")
    }

    func changeStartState(to state: StateQ) {
        algorithm.startingStateId = state.id
        algorithm.activeStateId = state.id
        algorithm.lastEditDate = Date.now
        try? context.save()
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetcher = CoreDataFetcher.shared
    let algorithm = fetcher.fetchEntities(
        ofType: Algorithm.self,
        withPredicate: nil,
        in: context
    )[0]
    return StartStateListView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

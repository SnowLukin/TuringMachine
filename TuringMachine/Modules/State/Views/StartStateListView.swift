//
//  StartStateListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct StartStateListView: View {

    @ObservedObject var algorithm: CDAlgorithm

    var body: some View {
        GenericStateList(
            states: algorithm.unwrappedStates,
            selectedStateId: algorithm.startingStateId
        ) { state in
            changeStartState(to: state)
        }
        .navigationTitle("Current state")
    }

    func changeStartState(to state: CDMachineState) {
        try? algorithm.updateStartState(to: state)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return StartStateListView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

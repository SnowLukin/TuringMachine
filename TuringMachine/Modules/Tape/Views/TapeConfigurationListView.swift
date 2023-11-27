//
//  TapeConfigurationListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 22.11.2023.
//

import SwiftUI

struct TapeConfigurationListView: View {

    @Environment(\.managedObjectContext) private var context
    @ObservedObject var algorithm: CDAlgorithm
    @State private var showNewTapeAlert = false

    var body: some View {
        ScrollView {
            ForEach(algorithm.unwrappedTapes) { tape in
                TapeSectionOpeningView(tape: tape, algorithm: algorithm)
            }
        }
        .navigationTitle("Tapes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add Tape") { showNewTapeAlert.toggle() }
                    .disabled(algorithm.unwrappedTapes.count > 10)
            }
        }
        .alert("New tape", isPresented: $showNewTapeAlert) {
            TextFieldAlert(placeholder: "New tape name") { tapeName in
                createTape(with: tapeName)
            }
        }
    }

    func createTape(with name: String) {
        withAnimation {
            try? CDTape.create(name: name, algorithm: algorithm, in: context)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return NavigationView {
        TapeConfigurationListView(algorithm: algorithm)
    }.environment(\.managedObjectContext, context)
}

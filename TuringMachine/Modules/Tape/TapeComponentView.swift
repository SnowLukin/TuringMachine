//
//  TapeComponentView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI
import CoreData

struct TapeComponentView: View {

    let component: (index: Int, value: String)
    @ObservedObject var tape: Tape
    let algorithm: Algorithm

    @Environment(\.managedObjectContext) private var context

    var body: some View {
        Button(action: changeHeadIndex) {
            Text(component.value)
                .foregroundColor(
                    tape.headIndex == component.index
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    tape.headIndex == component.index
                    ? .blue
                    : Color.secondaryBackground
                )
                .cornerRadius(35 / 2)
                .overlay(
                    Circle()
                        .stroke(.secondary)
                )
        }
    }

    func changeHeadIndex() {
        tape.headIndex = Int64(component.index)
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
    let tape = CoreDataFetcher.shared.tapesForAlgorithm(
        with: algorithm.id.unwrapped,
        in: context
    )[0]
    let component = (1, String(tape.input?.first ?? "-"))
    return TapeComponentView(component: component, tape: tape, algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

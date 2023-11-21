//
//  ComponentsLineView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct ComponentsLineView: View {

    @ObservedObject var tape: Tape
    let algorithm: Algorithm
    
    private var input: [Character] {
        Array(tape.input.unwrapped)
    }

    var body: some View {
        LazyHStack {
            ForEach(input.indices, id: \.self) { index in
                TapeComponentView(
                    component: (index, String(input[index])), 
                    tape: tape,
                    algorithm: algorithm
                )
                .id(index)
            }
        }.padding(.horizontal)
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
    let tape = fetcher.tapesForAlgorithm(
        with: algorithm.id.unwrapped,
        in: context
    )[0]
    return ComponentsLineView(tape: tape, algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

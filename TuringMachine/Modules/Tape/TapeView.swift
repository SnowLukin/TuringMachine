//
//  TapeView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct TapeView: View {

    @ObservedObject var tape: Tape
    let algorithm: Algorithm
    @State private var text: String = "-"

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { value in
                    ComponentsLineView(tape: tape, algorithm: algorithm)
                    .onAppear {
                        withAnimation {
                            value.scrollTo(tape.headIndex, anchor: .center)
                        }
                    }
                    .onChange(of: tape.headIndex) { newValue in
                        withAnimation {
                            value.scrollTo(newValue, anchor: .center)
                        }
                    }
            }
        }
        .frame(height: 40)
        .background(Color.secondaryBackground)
        .cornerRadius(9)
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
    return TapeView(tape: tape, algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

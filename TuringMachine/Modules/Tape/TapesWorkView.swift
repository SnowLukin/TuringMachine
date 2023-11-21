//
//  TapesWorkView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct TapesWorkView: View {

    @ObservedObject var algorithm: Algorithm
    
    private var tapes: [Tape] {
        algorithm.unwrappedTapes
    }

    var body: some View {
        ScrollView {
            ForEach(tapes.indices, id: \.self) { index in
                VStack(spacing: 0) {
                    Text("Tape \(index)")
                        .padding(.horizontal)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(.rect(topLeadingRadius: 6, topTrailingRadius: 6))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    TapeView(tape: tapes[index], algorithm: algorithm)
                }.padding(.horizontal)
            }
        }
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
    return TapesWorkView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

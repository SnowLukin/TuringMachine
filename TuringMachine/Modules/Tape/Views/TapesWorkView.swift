//
//  TapesWorkView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct TapesWorkView: View {

    @ObservedObject var algorithm: CDAlgorithm

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(algorithm.unwrappedTapes) { tape in
                    VStack(spacing: 0) {
                        Text(tape.name.unwrapped)
                            .padding(.horizontal)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(.rect(topLeadingRadius: 6, topTrailingRadius: 6))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        TapeView(tape: tape)
                    }
                }
            }.padding(.vertical)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return TapesWorkView(algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

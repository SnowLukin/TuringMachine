//
//  ComponentsLineView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct ComponentsLineView: View {

    @ObservedObject var tape: CDTape

    private var workingInputArray: [String] {
        tape.workingInput.unwrapped.map { String($0) }
    }

    var body: some View {
        LazyHStack {
            ForEach(workingInputArray.indices, id: \.self) { index in
                TapeComponentView(
                    component: (index, workingInputArray[index]),
                    tape: tape
                )
                .id(index)
            }
        }.padding(.horizontal)
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    let tape = CDTape.find(for: algorithm, in: context)[0]
    return ComponentsLineView(tape: tape)
        .environment(\.managedObjectContext, context)
}

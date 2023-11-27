//
//  TapeComponentView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct TapeComponentView: View {

    let component: (index: Int, value: String)
    @ObservedObject var tape: CDTape

    private var isActiveComponent: Bool {
        tape.workingHeadIndex == component.index
    }

    var body: some View {
        Button {
            try? tape.changeHeadIndex(to: component.index)
        } label: {
            Text(component.value)
                .foregroundColor(
                    isActiveComponent
                    ? .white
                    : .secondary
                )
                .font(.title2)
                .fontWeight(.semibold)
                .frame(width: 35, height: 35)
                .background(
                    isActiveComponent
                    ? Color.blue.shadow(.drop(radius: 1))
                    : Color.systemBackground.shadow(.drop(radius: 1))
                    , in: .rect(cornerRadius: isActiveComponent ? 30 : 10)
                )
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    let tape = CDTape.find(for: algorithm, in: context)[0]
    let component = (1, String(tape.input?.first ?? "-"))
    return TapeComponentView(component: component, tape: tape)
        .environment(\.managedObjectContext, context)
}

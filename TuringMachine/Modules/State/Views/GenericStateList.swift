//
//  GenericStateList.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import SwiftUI

struct GenericStateList: View {

    let states: [CDMachineState]
    let selectedStateId: String?
    let onTapAction: (CDMachineState) -> Void

    var body: some View {
        List {
            ForEach(states) { state in
                Text(state.name.unwrapped)
                    .foregroundColor(.primary)
                    .selectable(isStateSelected(state))
                    .onTapGesture {
                        withAnimation {
                            onTapAction(state)
                        }
                    }
            }
        }
    }

    private func isStateSelected(_ state: CDMachineState) -> Bool {
        guard let selectedStateId else { return false }
        return selectedStateId == state.id
    }
}

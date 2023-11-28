//
//  OptionDestinationStateButton.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import SwiftUI

struct OptionDestinationStateButton: View {

    @ObservedObject var option: CDOption

    var body: some View {
        NavigationLink {
            GenericStateList(
                states: option.getStates(),
                selectedStateId: option.toStateId
            ) { state in
                option.toStateId = state.id
            }.navigationTitle("Destination States")
        } label: {
            HStack {
                Text(option.fetchToState()?.name ?? "Not found")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .alignHorizontally(.leading)
                Spacer()
                Image(systemName: "chevron.right")
                    .bold()
                    .foregroundStyle(.white)
            }
            .padding()
            .background(.blue.gradient, in: .rect(cornerRadius: 10))
            .padding(.horizontal)
        }.buttonStyle(.plain)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let option = CDOption.findAll(in: context)[0]
    return NavigationStack {
        OptionDestinationStateButton(option: option)
            .environment(\.managedObjectContext, context)
    }
}

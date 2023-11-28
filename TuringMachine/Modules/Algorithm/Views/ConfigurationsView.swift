//
//  ConfigurationsView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct ConfigurationsView: View {

    @ObservedObject var algorithm: CDAlgorithm
    @Binding var isOpened: Bool

    var body: some View {
        VStack {
            Button {
                withAnimation {
                    isOpened.toggle()
                }
            } label: {
                Label(
                    isOpened ? "Hide settings" : "Show settings",
                    systemImage: isOpened ? "chevron.up" : "chevron.down"
                )
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 10)
                    .alignHorizontally(.center)
                    .background(.blue.gradient, in: .capsule)
            }
            .buttonStyle(.plain)
            .alignHorizontally(.center)
            .padding()

            if isOpened {
                VStack {
                    section("Configuration")
                    ListNavigationButtonView(text: "Tapes") {
                        TapeConfigurationListView(algorithm: algorithm)
                    }

                    ListNavigationButtonView(text: "States") {
                        StateListView(algorithm: algorithm)
                    }
                    .padding(.bottom)

                    section("Active state")
                    ListNavigationButtonView(text: getActiveStateName()) {
                        StartStateListView(algorithm: algorithm)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }.background(Color.secondaryBackground)
    }

    @ViewBuilder
    private func section(_ name: String) -> some View {
        Text(name)
            .font(.body.weight(.semibold))
            .alignHorizontally(.leading)
    }

    func getActiveStateName() -> String {
        let states = algorithm.unwrappedStates
        let activeStateId = algorithm.activeStateId
        let activeState = states.first { $0.id == activeStateId }
        guard activeStateId != nil, let activeState else {
            return "Not selected"
        }
        return activeState.name.unwrapped
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    return NavigationStack {
        ConfigurationsView(algorithm: algorithm, isOpened: .constant(true))
            .environment(\.managedObjectContext, context)
    }
}

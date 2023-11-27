//
//  CombinationConfigurationView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 22.11.2023.
//

import SwiftUI

struct CombinationConfigurationView: View {

    @ObservedObject var combination: CDCombination

    @State private var fromChar = ""
    @State private var currentDirection: Direction = .stay
    @State private var toChar = ""

    var body: some View {
        HStack(spacing: 0) {
            TextField("fromChar", text: $fromChar)
                .submitLabel(.done)
                .multilineTextAlignment(.center)
            Divider()
            Menu {
                ForEach(Direction.allCases) { direction in
                    Button {
                        withAnimation {
                            currentDirection = direction
                            try? combination.update(direction: direction)
                        }
                    } label: {
                        Label(direction.id, systemImage: direction.imageName)
                    }
                }
            } label: {
                currentDirection.image()
                    .frame(width: 50, height: 50)
            }
            Divider()
            TextField("toChar", text: $toChar)
                .submitLabel(.done)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .background(Color.secondaryBackground)
        .frame(height: 50)
        .onAppear {
            fromChar = combination.fromChar.unwrapped
            toChar = combination.toChar.unwrapped
            currentDirection = Direction.make(from: Int(combination.directionIndex))
        }
        .onChange(of: toChar) { newValue in
            toChar = String(newValue.prefix(1))
            try? combination.update(toChar: toChar)
        }
        .onChange(of: fromChar) { newValue in
            fromChar = String(newValue.prefix(1))
            try? combination.update(fromChar: fromChar)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let combination = CDCombination.findAll(in: context)[0]
    return CombinationConfigurationView(combination: combination)
        .environment(\.managedObjectContext, context)
}

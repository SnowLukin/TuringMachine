//
//  TapeConfigurationView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 22.11.2023.
//

import SwiftUI

struct TapeSectionOpeningView: View {

    @ObservedObject var tape: CDTape
    @ObservedObject var algorithm: CDAlgorithm

    @State private var inputTf = ""

    var body: some View {
        VStack(spacing: 15) {
            Text(tape.name.unwrapped)
                .font(.title.bold())
                .foregroundColor(.gray)
                .alignHorizontally(.leading)

            VStack(spacing: 5) {
                Text("Input")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .alignHorizontally(.leading)
                TextField("Tapes input", text: $inputTf)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .padding()
                    .background(Color.tertiaryBackground, in: .rect(cornerRadius: 10))
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                try? algorithm.removeTape(tape)
            } label: {
                Image(systemName: "xmark")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)
                    .padding(5)
                    .background(.red.gradient)
                    .clipShape(.circle)
            }
        }
        .padding()
        .background(Color(uiColor: .secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            inputTf = tape.input.unwrapped.filter { $0 != "-" }
        }
        .onChange(of: inputTf, perform: updateInput)
    }

    private func updateInput(_ text: String) {
        try? tape.updateInput(text)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    let tape = CDTape.find(for: algorithm, in: context)[0]
    return TapeSectionOpeningView(tape: tape, algorithm: algorithm)
        .environment(\.managedObjectContext, context)
}

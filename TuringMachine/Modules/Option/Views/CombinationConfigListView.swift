//
//  CombinationConfigListView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 23.11.2023.
//

import SwiftUI

struct CombinationConfigListView: View {

    @ObservedObject var option: CDOption

    var body: some View {
        VStack {
            ForEach(option.unwrappedCombinations) { combination in
                HStack(alignment: .bottom) {
                    Text(explanationText(for: combination))
                        .foregroundColor(Color.gray)
                        .alignHorizontally(.leading)
                    Button {
                        try? option.removeCombination(combination)
                    } label: {
                        Text("Remove")
                            .bold()
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.red.gradient, in: .rect(cornerRadius: 5))
                    }.alignHorizontally(.trailing)
                }
                .padding(.horizontal)
                CombinationConfigurationView(combination: combination)
            }
        }
    }

    func explanationText(for combination: CDCombination) -> String {
        let fromChar = combination.fromChar.unwrapped
        let toChar = combination.toChar.unwrapped
        return "From \(fromChar) to \(toChar)"
    }
}

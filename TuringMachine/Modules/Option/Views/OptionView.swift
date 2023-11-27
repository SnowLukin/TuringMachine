//
//  OptionView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 22.11.2023.
//

import SwiftUI

struct OptionView: View {

    @ObservedObject var option: CDOption

    var body: some View {
        ScrollView {
            VStack {
                section("Destination State")
                OptionDestinationStateButton(option: option)
                Divider()
                section("Configurations")
                CombinationConfigListView(option: option)
            }.padding(.vertical)
        }
        .navigationTitle("Combination: \(option.joinedCombinations)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let option = CDOption.findAll(in: context)[0]
    return NavigationView {
        OptionView(option: option)
            .environment(\.managedObjectContext, context)
    }
}

extension OptionView {
    @ViewBuilder
    private func section(_ text: String) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.semibold)
            .alignHorizontally(.leading)
            .padding(.horizontal)
    }
}

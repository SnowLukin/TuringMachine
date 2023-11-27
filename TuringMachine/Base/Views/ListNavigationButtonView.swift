//
//  ListNavigationButtonView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 24.11.2023.
//

import SwiftUI

struct ListNavigationButtonView<Destination>: View where Destination: View {

    @Environment(\.colorScheme) private var colorScheme

    let text: String
    @ViewBuilder
    let destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack {
                Text(text)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right")
            }
            .padding()
            .background(
                colorScheme == .dark
                ? Color.tertiaryBackground
                : Color.systemBackground
            )
            .clipShape(.rect(cornerRadius: 10))
        }
        .foregroundStyle(.primary)
    }
}

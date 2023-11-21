//
//  SelectableViewModifier.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct SelectableViewModifier: ViewModifier {
    let isSelected: Bool

    func body(content: Content) -> some View {
        HStack {
            content
                .frame(maxWidth: .infinity, alignment: .leading)
            if isSelected {
                Image(systemName: "circle.fill")
                    .foregroundColor(.blue)
                    .transition(
                        AnyTransition.opacity.animation(
                            .easeInOut(duration: 0.2)
                        )
                    )
            }
        }.contentShape(.rect)
    }
}

extension View {
    func selectable(_ isSelected: Bool) -> some View {
        self.modifier(SelectableViewModifier(isSelected: isSelected))
    }
}

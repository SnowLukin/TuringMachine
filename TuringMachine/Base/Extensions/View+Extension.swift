//
//  View+Extension.swift
//  TuringMachine
//
//  Created by Snow Lukin on 13.11.2023.
//

import SwiftUI

extension View {
    @ViewBuilder
    func alignHorizontally(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func alignVertically(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
}

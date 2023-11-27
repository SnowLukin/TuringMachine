//
//  TapeView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct TapeView: View {

    @ObservedObject var tape: CDTape

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                ComponentsLineView(tape: tape)
            }
            .onAppear {
                scrollToHeadIndex(in: proxy)
            }
            .onChange(of: tape.workingHeadIndex) { _ in
                withAnimation {
                    scrollToHeadIndex(in: proxy)
                }
            }
        }
        .frame(height: 55)
        .background(Color.secondaryBackground)
    }

    private func scrollToHeadIndex(in proxy: ScrollViewProxy) {
        // Tape head index has to be converted to Int
        // otherwise wont work
        proxy.scrollTo(Int(tape.workingHeadIndex), anchor: .center)
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let algorithm = CDAlgorithm.findAll(in: context)[0]
    let tape = CDTape.find(for: algorithm, in: context)[0]
    return TapeView(tape: tape)
        .environment(\.managedObjectContext, context)
}

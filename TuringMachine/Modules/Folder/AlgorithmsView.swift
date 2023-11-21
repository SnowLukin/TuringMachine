//
//  AlgorithmsView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct AlgorithmsView: View {
    @Environment(\.managedObjectContext) private var context

    let algorithms: [Algorithm]
    let folder: Folder

    var body: some View {
        ForEach(algorithms) { algorithm in
            AlgorithmCellView(algorithm: algorithm)
        }
        .onDelete(perform: deleteAlgorithm)
    }

    private func deleteAlgorithm(offsets: IndexSet) {
        withAnimation {
            let selectedAlgorithms = offsets.map { algorithms[$0] }
            selectedAlgorithms.forEach { algorithm in
                folder.removeFromAlgorithms(algorithm)
                context.delete(algorithm)
            }
            try? context.save()
        }
    }
}

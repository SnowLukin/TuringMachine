//
//  AlgorithmCellView.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct AlgorithmCellView: View {

    @ObservedObject var algorithm: Algorithm

    var body: some View {
        NavigationLink {
            
        } label: {
            VStack(alignment: .leading) {
                Text(algorithm.name.unwrapped)
                    .font(.headline)
                    .lineLimit(1)
                Text(algorithm.lastEditDate.unwrappedOrNow.algorithmFormat())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.buttonStyle(.plain)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let algorithm = CoreDataFetcher.shared.fetchEntities(
        ofType: Algorithm.self,
        withPredicate: nil,
        in: context
    )[0]
    return NavigationStack {
        AlgorithmCellView(algorithm: algorithm)
            .padding()
    }.environment(\.managedObjectContext, context)
}

private extension Date {
    func algorithmFormat() -> String {
        if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        }
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(self) {
            formatter.dateFormat = "HH:mm"
            return formatter.string(from: self)
        }
        formatter.dateFormat = "d MMM y"
        return formatter.string(from: self)
    }
}

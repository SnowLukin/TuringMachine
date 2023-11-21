//
//  NewAlgorithmButton.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct NewAlgorithmButton: View {

    @Environment(\.managedObjectContext) private var context
    let folder: Folder

    @State private var showNewAlgAlert = false
    @State private var algorithmName = ""

    var body: some View {
        Button {
            showNewAlgAlert.toggle()
        } label: {
            Image(systemName: "doc.badge.plus")
                .font(.title2)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .background(.ultraThickMaterial)
        .alert("New Algorithm", isPresented: $showNewAlgAlert) {
            TextField("Algorithm name", text: $algorithmName)
                .foregroundStyle(.black)
            Button("Cancel", role: .cancel) {}
            Button("Save", action: createAlgorithm)
        }
        .onChange(of: showNewAlgAlert) { newValue in
            if !newValue { algorithmName.removeAll() }
        }
    }

    func createAlgorithm() {
        withAnimation {
            let name = algorithmName.trimmingCharacters(in: .whitespaces)
            let algorithm = Algorithm(context: context)
            algorithm.id = UUID().uuidString
            algorithm.name = name
            algorithm.createdDate = .now
            algorithm.lastEditDate = .now
            folder.addToAlgorithms(algorithm)
            try? context.save()
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let folder = CoreDataFetcher.shared.fetchEntities(
        ofType: Folder.self,
        withPredicate: nil,
        in: context
    )[0]
    return NewAlgorithmButton(folder: folder)
        .environment(\.managedObjectContext, context)
}

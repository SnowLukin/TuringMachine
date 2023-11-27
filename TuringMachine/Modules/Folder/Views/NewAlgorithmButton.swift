//
//  NewAlgorithmButton.swift
//  TuringMachine
//
//  Created by Snow Lukin on 21.11.2023.
//

import SwiftUI

struct NewAlgorithmButton: View {
    @Environment(\.managedObjectContext) private var context
    @ObservedObject var folder: CDFolder
    @State private var showNewAlgAlert = false

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
            TextFieldAlert(placeholder: "Algorithm name") { algorithmName in
                createAlgorithm(with: algorithmName)
            }
        }
    }

    func createAlgorithm(with name: String) {
        try? CDAlgorithm.create(name: name, folder: folder, in: context)
    }
}

#Preview {
    let context = PersistenceController.preview.context
    let folder = CDFolder.findAll(in: context)[0]
    return NewAlgorithmButton(folder: folder)
        .environment(\.managedObjectContext, context)
}
